//
//  RouterContract.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev on 22.12.2020.
//  Copyright © 2020 TEXEN. All rights reserved.
//

import UIKit

protocol RouterContract: class {
    
    var currentController: UIViewController! {get set}
    var parent: RouterContract! {get set}
    
    init(parent: RouterContract!)
    
    func initialize() -> UIViewController
    //func alert(_ type: AlertBuilder, with delegate: AlertControllerDelegate?)
}
