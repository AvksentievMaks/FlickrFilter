//
//  CollectionCellFromNib.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import UIKit

class CollectionCellFromNib: UICollectionViewCell {
    
    var identifier: String {
        return "TableCellFromNib"
    }
}

extension CollectionCellFromNib: NibLoadable {}

//MARK: - UICollectionReusableView+ReusableView
extension UICollectionReusableView: ReusableView {}
