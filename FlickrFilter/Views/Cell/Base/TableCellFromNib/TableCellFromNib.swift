//
//  TableCellFromNib.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import UIKit

class TableCellFromNib: UITableViewCell {
    
    var identifier: String {
        return "TableCellFromNib"
    }
}

extension TableCellFromNib: NibLoadable {}

//MARK: - UITableViewCell+ReusableView
extension UITableViewCell: ReusableView {}
