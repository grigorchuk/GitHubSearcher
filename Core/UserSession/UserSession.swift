//
//  UserSession.swift
//  Core
//
//  Created by Artem Havriushov on 8/19/19.
//

import Foundation
import Swinject
import RealmSwift
import Kingfisher

struct UserSessionConstants {
    static let sessionStateKey: String = "SessionStateKey"
    static let accessTokenKey: String = "accessTokenKey"
}

/// Stores authorized user credentials and current user itself. Responsible for user related settings (per session)
public class UserSession {
    
    public enum State: Int {
        
        case initialized, opened, closed
        
    }
    
    public let container: Container
    
    public var userID: String {
        // returns `UserSession`'s ID cause they are the same with User ID.
        // If they will differ, need to store userID separatly for Realm fetching purposes.
        return id
    }
    
    public var shouldChangePassword: Bool {
        return sessionInfo.shouldChangePassword
    }
    
    public var proximityTracingConfiguration: ProximityTracingConfiguration? {
        return sessionInfo.proximityTracingConfiguration
    }
    
    private(set) public var state: State = .initialized {
        didSet {
            NotificationCenter.default.post(
                name: .userSessionStateDidChange,
                object: nil,
                userInfo: [UserSessionConstants.sessionStateKey: state]
            )
        }
    }
    
    let id: String
    /// Callbacks when user session was invalidated, so it should be closed
    var invalidated: ((Error) -> Void)?
    
    /// Current user
    /// - warning: Call it only on the main thread
    var user: UserObject {
        return sessionInfo.user
    }
    
    var accessToken: AccessToken {
        return sessionInfo.accessToken
    }
    
    private let credentialsStorage: KeyValueStorage = KeychainStorage()
    private var sessionInfo: UserSessionInfo
    private var realm: Realm { return container.autoresolve() }
    
    // MARK: - Init
    
    init(sessionInfo: UserSessionInfo, container: Swinject.Container) {
        self.id = sessionInfo.id
        self.sessionInfo = sessionInfo
        self.container = Container(parent: container)
    }
    
    init?(restorationID: String, container: Swinject.Container) {
        self.container = Container(parent: container)
        self.id = restorationID
        
        let accessTokenStorageKey = UserSession.accessTokenStorageKey(for: restorationID)
        let shouldChangePasswordStorageKey = UserSession.shouldChangePasswordStorageKey(for: restorationID)
        let proximityTracingConfigurationKey = UserSession.proximityTracingConfigurationKey(for: restorationID)
        let realm: Realm = container.autoresolve()
        
        guard let user = realm.object(ofType: UserObject.self, forPrimaryKey: Int(restorationID)),
            let tokenString = credentialsStorage.object(forKey: accessTokenStorageKey) as? String,
            let tokenData = tokenString.data(using: .utf8),
            let token = try? JSONDecoder().decode(AccessToken.self, from: tokenData),
            let changePasswordString = credentialsStorage.object(forKey: shouldChangePasswordStorageKey) as? String,
            let shouldChangePassword = Bool(changePasswordString) else {
                return nil
        }
        
        var proximityTracingConfg: ProximityTracingConfiguration?
        
        if let proximityTracingConfigString =
            credentialsStorage.object(forKey: proximityTracingConfigurationKey) as? String,
            let proximityTracingConfigData = proximityTracingConfigString.data(using: .utf8) {
            proximityTracingConfg = try? JSONDecoder()
                .decode(ProximityTracingConfiguration.self, from: proximityTracingConfigData)
        }

        let plainStorage: KeyValueStorage = UserDefaults.standard
        let proximityTracingTokenKey = generateProximityTracingTokenKey(forUserID: user.id)

        self.sessionInfo = UserSessionInfo(
            accessToken: token,
            user: user,
            proximityTracingConfiguration: proximityTracingConfg,
            shouldChangePassword: shouldChangePassword,
            proximityTracingToken: plainStorage.object(forKey: proximityTracingTokenKey) as? String
        )
    }

    // MARK: - User management
    
    /// Provides update user closure with fetched user from DB. If `realm` is nil, used default Realm
    /// - important: Safe to call on different threads
    func updateCurrentUser(in realm: Realm? = nil, updates: (UserObject?) -> Void) {
        let realm = realm ?? self.realm
        let user = fetchCurrentUser(in: realm)
        
        realm.forceWrite {
            updates(user)
        }
    }
    
    /// Updates a current user with provided one.
    func updateCurrentUser(in realm: Realm? = nil, with userObject: UserObject) {
        let realm = realm ?? self.realm
        
        realm.forceWrite {
            realm.add(userObject, update: .all)
        }
    }

    /// Fetches current user from DB. If `realm` is nil, used default Realm (main thread)
    /// - important: Safe to call on different threads
    func fetchCurrentUser(in realm: Realm? = nil) -> UserObject? {
        let realm = realm ?? self.realm
        
        return realm.object(ofType: UserObject.self, forPrimaryKey: Int(userID))
    }

    private func saveUser(in realm: Realm? = nil) {
        let realm = realm ?? self.realm
        
        realm.forceWrite {
            realm.add(user, update: .all)
        }
    }
    
    private func removeUser(in realm: Realm? = nil) {
        let realm = realm ?? self.realm
        guard let user = realm.object(ofType: UserObject.self, forPrimaryKey: Int(userID)) else { return }
        
        realm.forceWrite {
            realm.delete(user)
        }
    }
    
    // MARK: - Access Token Management
    
    private static func accessTokenStorageKey(for id: String) -> String {
        return ".userSession.accessToken.\(id)"
    }
    
    private func saveAccessToken() {
        //swiftlint:disable force_try
        let data = try! JSONEncoder().encode(accessToken)
        //swiftlint:enable force_try
        let tokenString = String(data: data, encoding: .utf8)!
        credentialsStorage.set(tokenString, forKey: UserSession.accessTokenStorageKey(for: id))
    }
    
    private func removeAccessToken() {
        credentialsStorage.set(nil, forKey: UserSession.accessTokenStorageKey(for: id))
    }
    
    /// Manually handle token invalidation from unauthorized error
    func handleInvalidatedToken(from error: Error) {
        invalidated?(error)
    }
    
    // MARK: - ShouldChangePassword Management
    
    private static func shouldChangePasswordStorageKey(for id: String) -> String {
        return ".userSession.shouldChangePassword.\(id)"
    }
    
    private func saveShouldChangePassword() {
        credentialsStorage.set(
            String(shouldChangePassword),
            forKey: UserSession.shouldChangePasswordStorageKey(for: id)
        )
    }
    
    private func removeShouldChangePassword() {
        credentialsStorage.set(nil, forKey: UserSession.shouldChangePasswordStorageKey(for: id))
    }
    
    func updateShouldChangePassword(_ shouldChange: Bool) {
        sessionInfo.shouldChangePassword = shouldChange
        saveShouldChangePassword()
    }
    
    // MARK: - Proximity Tracing Config Management
    
    private static func proximityTracingConfigurationKey(for id: String) -> String {
        return ".userSession.proximityTracingConfig.\(id)"
    }
    
    private func saveProximityTracingConfiguration() {
        guard let config = proximityTracingConfiguration else { return }
        
        //swiftlint:disable force_try
        let data = try! JSONEncoder().encode(config)
        //swiftlint:enable force_try
        let string = String(data: data, encoding: .utf8)!
        credentialsStorage.set(string, forKey: UserSession.proximityTracingConfigurationKey(for: id))
    }
    
    private func removeProximityTracingConfiguration() {
        credentialsStorage.set(nil, forKey: UserSession.proximityTracingConfigurationKey(for: id))
    }
    
    // MARK: - State
    
    func open() {
        assert(state == .initialized, "Session can be opened once")
        
        saveUser()
        saveAccessToken()
        saveShouldChangePassword()
        saveProximityTracingConfiguration()
        UserSessionAssembly(userSession: self).assemble(container: container)
        // since we shouldn't store any user's data (or at least try to do so),
        // it's better to clean up cache on app launch (in case if app crashed and cache hadn't been deleted)
        clearUserCache()
        startServices()
        
        state = .opened
    }
    
    func close() {
        assert(state == .opened, "Only opened session can be closed")
        
        stopServices()
        
        let realm = self.realm
        removeUser(in: realm)
        removeAccessToken()
        removeShouldChangePassword()
        removeProximityTracingConfiguration()
        
        clearUserCache()
        
        state = .closed
        container.removeAll()
    }
    
    // MARK: - Related services management
    
    func clearUserCache() {
        let cacheManager: CacheManager = container.autoresolve()
        try? cacheManager.removeAllCachedData(for: userID)
    }
    
    private func startServices() {
        let networkTaskLog: NetworkTaskLog = container.autoresolve()
        let networkTaskScheduler: NetworkTaskScheduler = container.autoresolve()
        
        networkTaskLog.start()
        networkTaskScheduler.start()
    }
    
    private func stopServices() {
        let networkTaskScheduler: NetworkTaskScheduler = container.autoresolve()
        networkTaskScheduler.stop()
        // For MVP Access Token updating logic is removed. It logouts instantly in case of unauthorized error
//        let accessTokenUpdater: AccessTokenUpdater = container.autoresolve()
//        accessTokenUpdater.cancel()
    }
    
}

extension UserSession: AccessTokenUpdaterDelegate {

    func accessTokenUpdaterRequiresAccessToken(_ updater: AccessTokenUpdater) -> AccessToken? {
        return accessToken
    }

    func accessTokenUpdater(_ updater: AccessTokenUpdater, didUpdateAccessToken accessToken: AccessToken) {
        sessionInfo.accessToken = accessToken
        saveAccessToken()
        NotificationCenter.default.post(
            name: .userSessionDidUpdateAccessToken,
            object: nil,
            userInfo: [UserSessionConstants.accessTokenKey: accessToken]
        )
    }

    func accessTokenUpdater(_ updater: AccessTokenUpdater,
                            didInvalidateAccessToken accessToken: AccessToken,
                            error: Error) {
        handleInvalidatedToken(from: error)
    }

}
