//
//  ArrayDataSource.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import UIKit

class ArrayDataSource<T, Cell>: TableDataSource<ArrayDataProvider<T>, Cell> where Cell: ConfigurableCell & TableCellFromNib, Cell.Item == T {
    
    //MARK: - Init
    public convenience init(tableView: UITableView, array: [T]) {
        
        self.init(tableView: tableView, array: [array])
    }
    
    public init(tableView: UITableView, array: [[T]]) {
        
        super.init(tableView: tableView, provider: ArrayDataProvider(array: array))
    }
    
    //MARK: - Public Methods
    public func item(at indexPath: IndexPath) -> T? {
        
        return self.provider.item(at: indexPath)
    }
    
    public func updateItem(at indexPath: IndexPath, value: T) {
        
        self.provider.updateItem(at: indexPath, value: value)
    }
}
