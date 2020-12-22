//
//  MainRouter.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev on 22.12.2020.
//  Copyright © 2020 TEXEN. All rights reserved.
//

import UIKit

class MainRouter {
    
    weak var currentController: UIViewController!
    var parent: RouterContract!

    //MARK: - Init
    required init(parent: RouterContract!) {
        
        self.parent = parent
    }
}

//MARK: - Main
extension MainRouter {
    
    func open(imageURL: URL) {
        
        let controller = ImageEditorController(self)
        controller.processor = ImageProcessor(url: imageURL)
        controller.providesPresentationContextTransitionStyle = true
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.currentController.present(controller, animated: true)
    }

}

//MARK: - RouterContract
extension MainRouter: RouterContract {
    
    func initialize() -> UIViewController {
            
        let controller = SearchController(self)//ImageCollectionController(self)
        self.currentController = controller
            
        return controller
    }
}
