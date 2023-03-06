//
//  AuthRequests.swift
//  Core
//
//  Created by Alex on 02.09.2020.
//  Copyright © 2020 Grigorchuk. All rights reserved.
//

import YALAPIClient

struct AuthorizeRequest: APIRequest {
    
    public let path = "user"
    public let method: APIRequestMethod = .get
    public var headers: [String: String]?
    
    public init(token: String) {
        headers = ["Authorization": "Basic \(token)"]
    }
}

struct UserRequest: APIRequest {
    
    public let path: String
    public let method: APIRequestMethod = .get
    public let headers: [String: String]?
    
    public init(username: String, authHeader: [String: String]) {
        path = "users/\(username)"
        headers = authHeader
    }
}

struct SearchRequest: APIRequest {
    
    public let path = "search/repositories"
    public let method: APIRequestMethod = .get
    public let parameters: [String: Any]?
    public let headers: [String: String]?
    
    public init(term: String, page: Int, authHeader: [String: String]) {
        parameters = ["q": term, "page": page, "sort": "stars"]
        headers = authHeader
    }
}
