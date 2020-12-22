//
//  ConfigurableCell.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import Foundation

public protocol ConfigurableCell {

    associatedtype Item
    
    func configure(_ item: Item, at indexPath: IndexPath)
}
