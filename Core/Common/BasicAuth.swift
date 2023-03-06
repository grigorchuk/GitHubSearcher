//
//  BasicAuth.swift
//  Core
//
//  Created by Alex on 03.09.2020.
//  Copyright © 2020 Grigorchuk. All rights reserved.
//

protocol BasicAuth {
    
    var userSession: UserSession { get }
    
}

extension BasicAuth {
    
    var basicAuthHeader: [String: String] {
        guard let token = userSession.token else { return [:] }
        
        return ["Authorization": "Basic \(token)"]
    }
}
