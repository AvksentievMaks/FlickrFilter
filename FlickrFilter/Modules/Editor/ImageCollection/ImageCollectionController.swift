//
//  ImageCollectionController.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev on 22.12.2020.
//  Copyright © 2020 TEXEN. All rights reserved.
//

import UIKit

class ImageCollectionController: BaseController {

    @IBOutlet weak var imageCollection: UICollectionView!
    
    var dataSource: ImageCollectionDataSource!
    var router: MainRouter!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
}

//MARK: - Init
extension ImageCollectionController {
    
    convenience init(_ router: MainRouter) {
        
        self.init()
        
        self.dataSource = ImageCollectionDataSource()
        self.router = router
    }
}

//MARK: - Configure
extension ImageCollectionController {
    
    override func configure() {
        
        super.configure()
        
        self.imageCollection.register(ImageCell.nib(), forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        self.imageCollection.dataSource = self.dataSource
        self.imageCollection.delegate = self
        
        self.dataSource.loadImages { success in
            
            DispatchQueue.main.async {
                success ? self.imageCollection.reloadData() : ()
            }
        }
    }
}

//MARK: - UICollectionViewDelegate
extension ImageCollectionController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.router.open(imageURL: self.dataSource.retriveURL(at: indexPath.row))
    }
}
