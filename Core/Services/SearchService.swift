//
//  SearchService.swift
//  Core
//
//  Created by Alex on 01.09.2020.
//  Copyright © 2020 Grigorchuk. All rights reserved.
//

import YALAPIClient

public typealias Result = YALAPIClient.Result

public final class SearchService: BasicAuth {
    
    let userSession: UserSession
    
    private let networkClient: NetworkClient
        
    public init(networkClient: NetworkClient, userSession: UserSession) {
        self.networkClient = networkClient
        self.userSession = userSession
    }
    
    public func search(by term: String, page: Int, completion: @escaping ((Result<SearchResult>) -> Void)) {
        let request = SearchRequest(term: term, page: page, authHeader: basicAuthHeader)
        let parser = DecodableParser<SearchResult>()
        
        networkClient.execute(request: request, parser: parser, completion: completion)
    }
}
