//
//  UserSessionController.swift
//  Core
//
//  Created by Artem Havriushov on 8/20/19.
//

import Foundation
import Swinject

func generateProximityTracingTokenKey(forUserID userID: Int) -> String {
    return "\(userID).proximityTracingTokenKey"
}

private let userSessionIdentifierKey = "\(Bundle.main.bundleIdentifier!).userSession.identifier"

/// Responsible for managing UserSession object: opening, closing, restoration.
public class UserSessionController {
    
    /// Calls when session has been invalidated / unexpectedly closed. May be called on background thread
    public var sessionInvalidated: ((Error) -> Void)?
    public var sessionWillInvalidate: (() -> Void)?
    
    public private(set) var userSession: UserSession? {
        didSet {
            oldValue?.close()
            
            userSession?.open()
            userSession?.invalidated = { [unowned self] error in
                self.sessionWillInvalidate?()
                guard self.userSession != nil else { return }
                
                self.invalidate(error)
            }
            
            userSessionIdentifier = userSession?.id
        }
    }
    
    private let storage: KeyValueStorage
    private let container: Swinject.Container
    
    private var userSessionIdentifier: String? {
        get {
            return storage.object(forKey: userSessionIdentifierKey) as? String
        }
        set {
            storage.set(newValue, forKey: userSessionIdentifierKey)
            storage.saveChanges()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Init
    
    public init(container: Swinject.Container, storage: KeyValueStorage = UserDefaults.standard) {
        self.storage = storage
        self.container = Container(parent: container)
        
        addApplicationStateObservers()
    }

    // MARK: – Observers

    private func addApplicationStateObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clearUserCache),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clearUserCache),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }
    
    @objc
    private func clearUserCache() {
        userSession?.clearUserCache()
    }

    // MARK: – Session management
    
    @discardableResult
    func createSession(userSessionInfo: UserSessionInfo) -> UserSession {
        userSession = UserSession(sessionInfo: userSessionInfo, container: container)
        applyProximityTracingToken(userSessionInfo.proximityTracingToken, for: userSessionInfo.user.id)

        return userSession!
    }
    
    public func closeSession() {
        assert(userSession != nil, "Can`t close nil session")
        
        userSession = nil
    }
    
    private func invalidate(_ error: Error) {
        closeSession()
        sessionInvalidated?(error)
    }
    
    // MARK: – Proximity Tracing Token management

    func proximityTracingToken(for userID: Int) -> String? {
        return storage.object(forKey: generateProximityTracingTokenKey(forUserID: userID)) as? String
    }

    private func applyProximityTracingToken(_ token: String?, for userID: Int) {
        storage.set(token, forKey: generateProximityTracingTokenKey(forUserID: userID))
        storage.saveChanges()
    }

    // MARK: - Session Restoration
    
    @discardableResult
    public func restorePreviousSession() -> UserSession? {
        assert(userSession == nil, "Can`t open 2 sessions")
        
        guard
            let identifier = userSessionIdentifier, !identifier.isEmpty,
            let session = UserSession(restorationID: identifier, container: container)
            else { return nil }
        
        self.userSession = session
        
        return session
    }
    
}
