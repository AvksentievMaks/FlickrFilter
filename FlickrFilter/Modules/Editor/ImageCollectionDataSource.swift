//
//  ImageCollectionDataSource.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev on 22.12.2020.
//  Copyright © 2020 TEXEN. All rights reserved.
//

import UIKit
import FlickrKit

class ImageCollectionDataSource: NSObject {

    var collection = [URL]()
    var processor: ImageProcessor?
}

//MARK: - Main
extension ImageCollectionDataSource {
    
    func initializeProcessor(at index: Int) {
        
        self.processor = ImageProcessor(url: self.collection[index])
    }
    
    func loadImages(_ completion: @escaping (Bool) -> Void) {
        
        FlickrKit.shared().call(FKFlickrInterestingnessGetList()) { [weak self] (response, error) in
            
            guard let response = response, let topPhotos = response["photos"] as? [String: AnyObject], let photoArray = topPhotos["photo"] as? [[NSObject: AnyObject]] else {
                
                completion(false)
                return
            }
        
            self?.collection = photoArray.compactMap {
                FlickrKit.shared().photoURL(for: FKPhotoSize.small240, fromPhotoDictionary: $0)
            }
            
            completion(true)
        }
    }
    
    func retriveURL(at index: Int) -> URL{
        
        return self.collection[index]
    }
}

//MARK: - UICollectionViewDataSource
extension ImageCollectionDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.collection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else {
            
            fatalError()
        }
        
        cell.setImage(from: self.collection[indexPath.row])
        
        return cell
    }
}
