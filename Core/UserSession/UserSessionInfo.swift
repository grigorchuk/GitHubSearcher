//
//  UserSessionInfo.swift
//  Core
//
//  Created by Artem Havriushov on 8/19/19.
//

import Foundation

struct UserSessionInfo {
    
    let id: String
    let user: UserObject
    let proximityTracingConfiguration: ProximityTracingConfiguration?
    let proximityTracingToken: String?
    var accessToken: AccessToken
    var shouldChangePassword: Bool

    init(
        accessToken: AccessToken,
        user: UserObject,
        proximityTracingConfiguration: ProximityTracingConfiguration?,
        shouldChangePassword: Bool,
        proximityTracingToken: String?
    ) {
        self.id = String(user.id)
        self.user = user
        self.accessToken = accessToken
        self.shouldChangePassword = shouldChangePassword
        self.proximityTracingConfiguration = proximityTracingConfiguration
        self.proximityTracingToken = proximityTracingToken
    }

}
