//
//  ControllerLoader.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev on 22.12.2020.
//  Copyright © 2020 TEXEN. All rights reserved.
//

import UIKit

protocol ControllerLoader {
    
    static var identifier: String {get}
    
    init()
    
    func load()
    func configure()
}

extension ControllerLoader where Self: UIViewController {
    
    init() {
        
        self.init(nibName: Self.identifier, bundle: Bundle.main)
        self.load()
    }
    
    init?(coder aDecoder: NSCoder) {
        
        self.init(coder: aDecoder)
    }
    
    func configure() {}
    
    func load() {}
}
