//
//  UITableView+Register.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import UIKit

//MARK: - ViewRegistration
extension UITableView: ViewRegistration {
    
    typealias Cell = UITableViewCell
    typealias ReusableCell = UITableViewHeaderFooterView
    typealias NibCell = TableCellFromNib
    
    func register(_: Cell.Type) {
        
        self.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func registerNib(_: NibCell.Type) {
        
        self.register(NibCell.nib(), forCellReuseIdentifier: NibCell.reuseIdentifier)
    }
    
    func dequeueReusableView(for indexPath: IndexPath) -> Cell? {
        
        self.register(Cell.self)
        
        return self.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath)
    }
    
    func dequeueReusableHeaderFooterView() -> ReusableCell? {
        
        self.register(ReusableCell.self, forHeaderFooterViewReuseIdentifier: ReusableCell.reuseIdentifier)
        
        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: ReusableCell.reuseIdentifier) else {
            
            fatalError("Could not dequeue Reusable HeaderFooterView with identifier: \(ReusableCell.reuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueReusableView(for indexPath: IndexPath) -> NibCell? {
        
        self.register(NibCell.self)
        
        guard let cell = self.dequeueReusableCell(withIdentifier: NibCell.reuseIdentifier, for: indexPath) as? NibCell else {
            
            fatalError("Could not dequeue cell with identifier: \(NibCell.reuseIdentifier)")
        }
        
        return cell
    }
    
    func registerReusableHeaderFooterView<T>(_: T.Type) where T : TableHeaderFooterFromNib {
        
        self.register(T.nib(), forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
}
