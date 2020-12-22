//
//  TableDataSource.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import UIKit

open class TableDataSource<Provider: DataProvider, Cell: ConfigurableCell & UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate where Cell: NibLoadable, Provider.T == Cell.Item {
    
    public var tableItemSelectionHandler: ItemSelectionHandlerType?
    
    let provider: Provider
    let tableView: UITableView
    
    // MARK: - Initialize
    init(tableView: UITableView, provider: Provider) {
        
        self.tableView = tableView
        self.provider = provider
        
        super.init()
        
        self.setUp()
    }
    
    //MARK: - Private
    fileprivate func setUp() {
        
        DispatchQueue.main.async {
            
            self.tableView.register(Cell.nib(), forCellReuseIdentifier: Cell.reuseIdentifier)
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    
    // MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.provider.numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.provider.numberOfItems(in: section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            
            return UITableViewCell()
        }
        
        if let item = self.provider.item(at: indexPath) {
            
            cell.configure(item, at: indexPath)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableItemSelectionHandler?(indexPath)
    }
}

open class CollectionDataSource<Provider: DataProvider, Cell: ConfigurableCell & UICollectionViewCell>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate where Cell: NibLoadable, Provider.T == Cell.Item {
    
    public var tableItemSelectionHandler: ItemSelectionHandlerType?
    
    let provider: Provider
    let collectionView: UICollectionView
    
    // MARK: - Initialize
    init(collectionView: UICollectionView, provider: Provider) {
        
        self.collectionView = collectionView
        self.provider = provider
        
        super.init()
        
        self.setUp()
    }
    
    //MARK: - Private
    fileprivate func setUp() {
        
        DispatchQueue.main.async {
            
//            self.collectionView.registerNib(Cell)
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
        }
    }
    
    // MARK: - UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return self.provider.numberOfSections()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.provider.numberOfItems(in: section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            
            return UICollectionViewCell()
        }
        
        if let item = self.provider.item(at: indexPath) {
            
            cell.configure(item, at: indexPath)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        self.tableItemSelectionHandler?(indexPath)
    }
}
