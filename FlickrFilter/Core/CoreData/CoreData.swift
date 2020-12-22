//
//  CoreData.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import CoreData

class CoreData: NSObject {
    
    private static let sharedInstance = CoreData()
    
    static var manager: CoreData {
        return sharedInstance
    }
    
    private let persistentContainer = NSPersistentContainer(name: "FlickrFilter")
    
    var viewContext: NSManagedObjectContext {
        
        return self.persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        
        return self.persistentContainer.newBackgroundContext()
    }
    
    //MARK: - Init
    private override init() {
        
        super.init()
        
        self.initialize()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: - Main
extension CoreData {

    func currentThreadContext() -> NSManagedObjectContext {
        
        return Thread.isMainThread ? self.viewContext : self.backgroundContext
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        
        self.persistentContainer.performBackgroundTask(block)
    }
    
    func save(_ context: NSManagedObjectContext) {
        
        if context.hasChanges {
            
            do{
                try context.save()
            } catch {
                
                //FIXME: log error
            }
        }
    }
}

//MARK: - Private
extension CoreData {
    
    private func initialize(completionHandler: @escaping (Bool) -> Void = {_ in}) {
        
        self.persistentContainer.loadPersistentStores { (_, error) in
            
            guard error == nil else {
                
                //FIXME: log error
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
        
        self.registerForDidSave()
    }
    
    fileprivate func registerForDidSave() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(CoreData.mocDidSaveNotification(_:)),
            name: .NSManagedObjectContextDidSave,
            object: nil
        )
        
        DispatchQueue.main.async {
            
            let _ = self.viewContext
            
            DispatchQueue.global(qos: .background).async {
                
                let _ = self.backgroundContext
            }
        }
    }
    
    @objc func mocDidSaveNotification(_ notification: Notification) {
        
        if let context = notification.object as? NSManagedObjectContext, context.persistentStoreCoordinator != self.viewContext.persistentStoreCoordinator || context == self.viewContext {
            
            return
        }
        
        DispatchQueue.main.async {
            
            self.viewContext.mergeChanges(fromContextDidSave: notification)
        }
    }
}
