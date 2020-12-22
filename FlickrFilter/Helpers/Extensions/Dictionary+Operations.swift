//
//  Dictionary+Operations.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import Foundation

extension Dictionary {
    
    static func += (lhs: inout Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) {
        
        rhs.forEach { lhs.updateValue($0.value, forKey: $0.key) }
    }
    
    static func + (lhs: Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
        
        return lhs.merging(rhs, uniquingKeysWith: { (_, last) in last })
    }
}
