//
//  ImageProvider.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev on 22.12.2020.
//  Copyright © 2020 TEXEN. All rights reserved.
//

import UIKit
import RxSwift

struct ImageProvider: RequestImages {
    
    fileprivate let downloadQueue = DispatchQueue(label: "Images cache", qos: DispatchQoS.background)
    internal var cache = NSCache<NSURL, UIImage>()

    //MARK: - Fetch image from URL and Images cache
    fileprivate func loadImages(from url: URL, completion: @escaping (_ image: UIImage) -> Void) {
        
        downloadQueue.async(execute: { () -> Void in
            
            if let image = self.cache.object(forKey: url as NSURL) {
                
                DispatchQueue.main.async {

                    completion(image)
                }
                
                return
            }
            
            do{
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: url as NSURL)
                        completion(image)
                    }
                } else {
                    print("Could not decode image")
                }
            }catch {
                print("Could not load URL: \(url): \(error)")
            }
        })
    }
    
    func add(filters values: [Filter: Int]?, to image: UIImage?, _ completion: @escaping (UIImage) -> Void) {
        
        guard let values = values, let image = image, var inputImage = CIImage(image: image) else {
            
            completion(UIImage())
            return
        }
        
        if values.count == 0 {
            
            completion(image)
            return
        }
        
        let ciContext = CIContext(options: nil)
        
        for value in values {
            
            if value.value != 0 {
                
                let ciFilter = value.key.ciFilter()
                value.key == .crystalize ? () : ciFilter.setValue(value.value, forKey: value.key.getChangeKey())
                ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
                inputImage = ciFilter.outputImage ?? inputImage
            }
        }
        
        
        guard let cgImage = ciContext.createCGImage(inputImage, from: CGRect(origin: CGPoint.zero, size: image.size)) else {
            
            completion(image)
            return
        }
        
        completion(UIImage(cgImage: cgImage))
    }
}

protocol RequestImages {}

extension RequestImages where Self == ImageProvider {
    
    func requestImage(from url: URL, completion: @escaping (_ image: UIImage) -> Void) {

        self.loadImages(from: url, completion: completion)
    }
}

