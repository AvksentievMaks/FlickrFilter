//
//  TableHeaderFooterFromNib.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import UIKit

class TableHeaderFooterFromNib: UITableViewHeaderFooterView {}

extension TableHeaderFooterFromNib: NibLoadable {}

//MARK: - UITableViewHeaderFooterView+ReusableView
extension UITableViewHeaderFooterView: ReusableView {}
