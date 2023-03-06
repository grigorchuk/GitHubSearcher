//
//  LastResult.swift
//  Core
//
//  Created by Alex on 03.09.2020.
//  Copyright © 2020 Grigorchuk. All rights reserved.
//

import RealmSwift

public class LastResult: Object, Decodable {
    
    @objc public dynamic var id = -1
    
    public var items = List<Repository>()
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    public convenience init(repositories: [Repository]) {
        self.init()
        items.append(objectsIn: repositories)
    }
    
    public required init() {
        super.init()
    }
    
}
