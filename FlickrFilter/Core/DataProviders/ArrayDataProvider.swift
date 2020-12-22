//
//  ArrayDataProvider.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import Foundation

public typealias ItemSelectionHandlerType = (IndexPath) -> Void

public class ArrayDataProvider<T> {
    
    var items: [[T]] = []
    
    //MARK: - Init
    init(array: [[T]]) {
        
        self.items = array
    }
}

//MARK: - DataProvider
extension ArrayDataProvider: DataProvider {
    
    public func numberOfSections() -> Int {
        
        return self.items.count
    }
    
    public func numberOfItems(in section: Int) -> Int {
        
        return (section >= 0 && section < self.items.count) ? self.items[section].count : 0
    }
    
    public func item(at indexPath: IndexPath) -> T? {
        
        guard indexPath.section >= 0 && indexPath.section < self.items.count && indexPath.row >= 0 && indexPath.row < self.items[indexPath.section].count else {
            
            return nil
        }
        
        return self.items[indexPath.section][indexPath.row]
    }
    
    public func updateItem(at indexPath: IndexPath, value: T) {
        
        guard indexPath.section >= 0 && indexPath.section < self.items.count && indexPath.row >= 0 && indexPath.row < self.items[indexPath.section].count else {
            
            return
        }
        
        self.items[indexPath.section][indexPath.row] = value
    }
}
