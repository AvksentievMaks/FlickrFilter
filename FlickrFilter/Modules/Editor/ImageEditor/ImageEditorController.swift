//
//  ImageEditorController.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev on 22.12.2020.
//  Copyright © 2020 TEXEN. All rights reserved.
//

import UIKit

class ImageEditorController: BaseController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterButton: UIButton!

    @IBOutlet weak var sepiaSwitch: UISwitch!
    @IBOutlet weak var monochromeSwitch: UISwitch!
    @IBOutlet weak var blurSlider: UISlider!
        
    var processor: ImageProcessor!
    weak var router: MainRouter!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.processor.loadImage { [weak self] image in
            
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
    
}

//MARK: - Init
extension ImageEditorController {
    
    convenience init(_ router: MainRouter) {
        
        self.init()
        
        self.router = router
    }
}

//MARK: - Configure
extension ImageEditorController {
    
    override func configure() {
        
        super.configure()
        
        
    }
    
}

//MARK: - Actions
extension ImageEditorController {
    
    @IBAction func blurFilter() {
        
        self.imageView.image = self.processor.change(filter: Filter.crystalize, value: 1)
//        self.imageView.image = self.processor.change(filter: Filter.blur, value: 10)
//        self.imageView.image = self.processor.change(filter: Filter.sepia, value: 0)
//        self.imageView.image = self.processor.change(filter: Filter.blur, value: 0)
    }
    
    @IBAction func savePicButton() {
        
        self.processor.saveImage()
            
        let alert = UIAlertView(title: "Filters",
                        message: "Your image has been saved to Photo Library",
                        delegate: nil,
                        cancelButtonTitle: "OK")
        alert.show()
    }
    
    @IBAction func dismiss() {
        
        self.dismiss(animated: true)
    }
}
