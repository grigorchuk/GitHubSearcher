//
//  AuthService.swift
//  Core
//
//  Created by Alex on 01.09.2020.
//  Copyright © 2020 Grigorchuk. All rights reserved.
//

import YALAPIClient

public final class AuthService {
    
    private let networkClient: NetworkClient
    
    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    public func authorize(with token: String, completion: @escaping ((Result<User>) -> Void)) {
        let request = AuthorizeRequest(token: token)
        let parser = DecodableParser<User>()
        
        networkClient.execute(request: request, parser: parser, completion: completion)
    }
}
