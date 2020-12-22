//
//  ImageProcessor.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev on 22.12.2020.
//  Copyright © 2020 TEXEN. All rights reserved.
//

import RxSwift
import UIKit
import CoreImage

typealias FilterType = (CIFilter, Int)

enum Filter: String {

    case sepia = "CISepiaTone"
    case crystalize = "CIPhotoEffectNoir"
    case blur = "CIGaussianBlur"
    
    func ciFilter() -> CIFilter {
        switch self {
        case .crystalize:
            return CIFilter(name: self.rawValue) ?? CIFilter()
        default:
            return CIFilter(name: self.rawValue, parameters: [self.getChangeKey(): 0]) ?? CIFilter()
        }
        
    }
    
    func getChangeKey() -> String {
        
        switch self {
        case .sepia:
            return kCIInputIntensityKey
        case .crystalize:
            return ""//kCIInputIntensityKey
        case .blur:
            return kCIInputRadiusKey
        }
    }
}

class ImageProcessor {
    
    var url: URL
    var image: UIImage!
    var filteredImage: UIImage!
    var filters: [Filter: FilterType]!
    
    //MARK: - Init
    init(url: URL) {
        
        self.url = url
        self.initialize()
    }
    
    func initialize() {
        
        self.filters = [Filter.sepia: (Filter.sepia.ciFilter(), 0), Filter.crystalize: (Filter.crystalize.ciFilter(), 0), Filter.blur: (Filter.blur.ciFilter(), 0)]
    }
    
    //MARK: - Main
    func loadImage(_ completion: @escaping (UIImage?) -> Void) {
        
        DispatchQueue.global().async {
            
            guard let data = try? Data(contentsOf: self.url) else {
                
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                
                self?.image = UIImage(data: data)
                self?.filteredImage = self?.image
                completion(self!.image)
            }
        }
    }
    
    func saveImage() {
        
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
    }
    
    
    func get(filter: Filter, to image: UIImage, value: Int) -> UIImage {
        
        let ciContext = CIContext(options: nil)
        var inputImage = CIImage(image: image)
        let extent = inputImage!.extent
        self.filters.forEach { (element) in
            
            if element.key == filter {
                
                var newElement = element
                newElement.value.1 = value
                
                newElement.value.0.setValue(newElement.value.1, forKey: filter.getChangeKey())
                newElement.value.0.setValue(inputImage, forKey: kCIInputImageKey)
                inputImage = newElement.value.0.outputImage!
                self.filters[newElement.key] = newElement.value
            }
        }
        
        return UIImage(cgImage: ciContext.createCGImage(inputImage!, from: extent)!)
    }
    
    func change(filter: Filter, value: Int) -> UIImage {
        
        let ciContext = CIContext(options: nil)
        var inputImage = CIImage(image: self.image)
        let extent = inputImage!.extent
        self.filters.forEach { (element) in
            
            if element.key == filter {
                
                var newElement = element
                newElement.value.1 = value
                
                newElement.value.0.setValue(newElement.value.1, forKey: filter.getChangeKey())
                newElement.value.0.setValue(inputImage, forKey: kCIInputImageKey)
                inputImage = newElement.value.0.outputImage!
                self.filters[newElement.key] = newElement.value
            }
        }
        
        self.filteredImage = UIImage(cgImage: ciContext.createCGImage(inputImage!, from: extent)!)
        
        return self.filteredImage
    }
    
    func addBlur() -> UIImage {
        
        // convert UIImage to CIImage
        let inputCIImage = CIImage(image: self.image)!
        
        // Create Blur CIFilter, and set the input image
        
        let blurFilter = CIFilter(name: "CIGaussianBlur")!
        blurFilter.setValue(inputCIImage, forKey: kCIInputImageKey)
        blurFilter.setValue(8, forKey: kCIInputRadiusKey)
        
        // Get the filtered output image and return it
        let outputImage = blurFilter.outputImage!
        
        self.image = UIImage(ciImage: outputImage)
        
        return self.image
    }
}
