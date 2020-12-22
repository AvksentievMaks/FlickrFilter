//
//  ViewRegistration.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import Foundation

protocol ViewRegistration: class {
    
    associatedtype Cell: ReusableView
    associatedtype ReusableCell: ReusableView
    associatedtype NibCell: ReusableView & NibLoadable
    
    func register(_: Cell.Type)
    
    func registerNib(_: NibCell.Type)
    
    func dequeueReusableView(for indexPath: IndexPath) -> Cell?
    
    func dequeueReusableView(for indexPath: IndexPath) -> ReusableCell?
    
    func register(_: ReusableCell.Type, forSupplementaryViewOfKind kind: String)
    
    func dequeueReusableSupplementaryView(ofKind kind: String, for indexPath: IndexPath) -> ReusableCell?
    
    
    func dequeueReusableHeaderFooterView() -> ReusableCell?
    
    func dequeueReusableView(for indexPath: IndexPath) -> NibCell?
    
    func registerReusableHeaderFooterView<T: TableHeaderFooterFromNib>(_: T.Type)
}

extension ViewRegistration {
    
    func dequeueReusableHeaderFooterView() -> ReusableCell? {return nil}
    func dequeueReusableView(for indexPath: IndexPath) -> NibCell? {return nil}
    func registerReusableHeaderFooterView<T>(_: T.Type) where T : TableHeaderFooterFromNib {}
    
    func register(_: ReusableCell.Type, forSupplementaryViewOfKind kind: String) {}
    func dequeueReusableSupplementaryView(ofKind kind: String, for indexPath: IndexPath) -> ReusableCell? {return nil}
    func dequeueReusableView(for indexPath: IndexPath) -> ReusableCell? {return nil}
}
