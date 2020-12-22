//
//  RootRouter.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © TEXEN. All rights reserved.
//

import UIKit

class RootRouter {

    var currentController: UIViewController!
    
    var parent: RouterContract!
    
    //MARK: - Init
    required init(parent: RouterContract! = nil) {
        
        self.parent = parent
    }
}
//MARK: - Main
extension RootRouter {
    
    func setRootViewController(controller: UIViewController, animatedWithOptions: UIView.AnimationOptions?) {
        
        guard let window = UIApplication.shared.keyWindow else {
            
            fatalError("No window in app")
        }
        
        window.rootViewController = controller
        
        if let animationOptions = animatedWithOptions, window.rootViewController != nil {
            
            UIView.transition(with: window, duration: 0.33, options: animationOptions, animations: {})
        }
    }
    
    func loadMainAppStructure() {
        // Customize your app structure here
        let controller = MainRouter(parent: self).initialize()
//        controller.view.backgroundColor = UIColor.red
        self.setRootViewController(controller: controller, animatedWithOptions: nil)
    }
}

//MARK: - RouterContract
extension RootRouter: RouterContract {
    
    func initialize() -> UIViewController {
        
        return UIViewController()
    }
}

