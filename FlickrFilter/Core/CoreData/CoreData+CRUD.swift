//
//  CoreData+CRUD.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import Foundation
import CoreData

//MARK: - CRUDProtocol
extension CoreData: CRUDProtocol {
    
    func read<T: NSManagedObject>(_ context: NSManagedObjectContext, parametrs: [String: Any?]? = nil, sortByKey: String? = nil, ascending: Bool = true) -> [T] {
        
        var array = [T]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "\(T.self)")
        
        if sortByKey != nil {
            
            let sortDescriptor = NSSortDescriptor(key: sortByKey, ascending: ascending)
            request.sortDescriptors = [sortDescriptor]
        }
        
        if let parametrs = parametrs, parametrs.count > 0 {
            
            var predicates = [NSPredicate]()
            for (key, value) in parametrs {
                
                switch value {
                case let predicate as String:
                    predicates.append(NSPredicate(format: "\(key) ==[c] %@", predicate))
                case let predicate as Int:
                    predicates.append(NSPredicate(format: "\(key) == %d", predicate))
                case let predicate as Float:
                    predicates.append(NSPredicate(format: "\(key) == %f", predicate))
                case let predicate as Double:
                    predicates.append(NSPredicate(format: "\(key) == %f", predicate))
                case let predicate as Bool:
                    predicates.append(NSPredicate(format: "\(key) == %@", predicate ? NSNumber(value: true) : NSNumber(value: false)))
                default:
                    break
                }
            }
            
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            request.predicate = predicate
        }
        
        request.returnsDistinctResults = true
        request.returnsObjectsAsFaults = false
        
        if let results = try? context.fetch(request) as? [T] {
            array += results ?? []
        }
        
        return array
    }
    
    func create<T: NSManagedObject>(_ context: NSManagedObjectContext, parametrs: [String: Any?]) -> T? {
        
        let record = NSEntityDescription.insertNewObject(forEntityName: "\(T.self)",
            into: context)
        
        for (key, value) in parametrs {
            if let value = value {
                record.setValue(value, forKey: key)
            }
        }
        
        self.save(context)
        
        return record as? T
    }
    
    func createOrUpdate<T: NSManagedObject>(_ context: NSManagedObjectContext, primary: [String: Any?], secondary: [String: Any?]) -> T? {
        
        let records: [T] = self.read(context, parametrs: primary)
        
        guard records.count != 0 else {
            return self.create(context, parametrs: primary + secondary)
        }
        
        let record = records[0] as NSManagedObject
        
        for (key, value) in secondary {
            
            if let value = value {
                record.setValue(value, forKey: key)
            }
        }
        
        self.save(context)
        
        return record as? T
    }
    
    func delete<T: NSManagedObject>(_ context: NSManagedObjectContext, parametrs: [String: Any?]) -> T? {
        
        let records: [T] = self.read(context, parametrs: parametrs)
        
        guard records.count != 0 else {
            return nil
        }
        
        let record = records[0] as NSManagedObject
        context.delete(record)
        self.save(context)
        
        return record as? T
    }
}
