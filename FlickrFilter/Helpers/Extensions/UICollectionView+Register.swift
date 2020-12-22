//
//  UICollectionView+Register.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import UIKit

//MARK: - ViewRegistration
extension UICollectionView: ViewRegistration {

    typealias Cell = UICollectionViewCell
    typealias ReusableCell = UICollectionReusableView
    typealias NibCell = CollectionCellFromNib

    func register(_: Cell.Type) {
        
        self.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func register(_: ReusableCell.Type, forSupplementaryViewOfKind kind: String) {
     
        self.register(ReusableCell.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: ReusableCell.reuseIdentifier)
    }
    
    func registerNib(_: NibCell.Type) {
        
        self.register(NibCell.nib(), forCellWithReuseIdentifier: NibCell.reuseIdentifier)
    }
    
    func dequeueReusableView(for indexPath: IndexPath) -> ReusableCell? {
        
        self.register(NibCell.self)
        
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: NibCell.reuseIdentifier, for: indexPath) as? NibCell else {
            
            fatalError("Could not dequeue cell with identifier: \(NibCell.reuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueReusableView(for indexPath: IndexPath) -> Cell? {
        
        self.register(Cell.self)
        
        return self.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath)
    }
    
    func dequeueReusableSupplementaryView(ofKind kind: String, for indexPath: IndexPath) -> ReusableCell? {
        
        self.register(ReusableCell.self, forSupplementaryViewOfKind: kind)
    
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReusableCell.reuseIdentifier, for: indexPath)
    }

}
