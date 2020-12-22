//
//  CRUDProtocol.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import CoreData

protocol CRUDProtocol {
    
    func create<T: NSManagedObject>(_ context: NSManagedObjectContext, parametrs: [String: Any?]) -> T?
    
    func read<T: NSManagedObject>(_ context: NSManagedObjectContext, parametrs: [String: Any?]?, sortByKey: String?, ascending: Bool) -> [T]
    
    func createOrUpdate<T: NSManagedObject>(_ context: NSManagedObjectContext, primary: [String: Any?], secondary: [String: Any?]) -> T?
    
    func delete<T: NSManagedObject>(_ context: NSManagedObjectContext, parametrs: [String: Any?]) -> T?
}
