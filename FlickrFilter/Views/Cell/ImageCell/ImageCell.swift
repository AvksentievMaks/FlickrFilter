//
//  ImageCell.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev on 22.12.2020.
//  Copyright © 2020 TEXEN. All rights reserved.
//

import UIKit
import RxSwift

class ImageCell: CollectionCellFromNib {

    override var identifier: String {
        return "ImageCell"
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    var dispose = DisposeBag()

    override func prepareForReuse() {
        
        self.dispose = DisposeBag()
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func setImage(from url: URL) {
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = UIImage(data: data!)
            }
        }
    }
}
