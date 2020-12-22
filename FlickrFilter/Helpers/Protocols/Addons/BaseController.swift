//
//  BaseController.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev on 22.12.2020.
//  Copyright © 2020 TEXEN. All rights reserved.
//

import UIKit

class BaseController: UIViewController {

    class var identifier: String {
        return String(describing: self)
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {

        super.viewDidLoad()

        self.configure()
    }
}

//MARK: - Configure
extension BaseController {
    
    @objc func configureNavigation() {
    
    }
}

//MARK: - ControllerLoader
extension BaseController: ControllerLoader {
 
    func load() {}
    
    @objc func configure() {}
}
