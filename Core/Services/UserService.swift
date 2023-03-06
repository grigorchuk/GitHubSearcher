//
//  UserService.swift
//  Core
//
//  Created by Alex on 02.09.2020.
//  Copyright © 2020 Grigorchuk. All rights reserved.
//

import YALAPIClient

public final class UserService: BasicAuth {
    
    let userSession: UserSession
    
    private let networkClient: NetworkClient
    
    public init(networkClient: NetworkClient, userSession: UserSession) {
        self.networkClient = networkClient
        self.userSession = userSession
    }
    
    public func fecthUser(username: String, completion: @escaping ((Result<User>) -> Void)) {
        let request = UserRequest(username: username, authHeader: basicAuthHeader)
        let parser = DecodableParser<User>()
        
        networkClient.execute(request: request, parser: parser, completion: completion)
    }
}
