//
//  NibLoadable.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import UIKit

public protocol NibLoadable: class {
    
    static var nibName: String { get }
    static func nib() -> UINib
}

extension NibLoadable where Self: UIView {
    
    static var nibName: String {
        
        return String(describing: self)
    }
    
    static func nib() -> UINib {
        
        return UINib(nibName: self.nibName, bundle: Bundle.main)
    }
}
