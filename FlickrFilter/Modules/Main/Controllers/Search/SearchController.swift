//
//  SearchController.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev on 22.12.2020.
//  Copyright © 2020 TEXEN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchController: BaseController, AlertMessage {
    
    fileprivate let downloadQueue = DispatchQueue(label: "Images cache", qos: DispatchQoS.background)
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.becomeFirstResponder()
        }
    }
    @IBOutlet weak var collectionResult: UICollectionView!
    @IBOutlet weak var labelLoading: UILabel!
    @IBOutlet weak var sepiaSwitch: UISwitch!
    @IBOutlet weak var monochromeSwitch: UISwitch!
    @IBOutlet weak var blurSwitch: UISwitch!
    @IBOutlet weak var blurSlider: UISlider!
    
    fileprivate var searchPhotos = [Photo]()
    fileprivate let router = Router()
    fileprivate var pageCount = 0
    fileprivate let imageProvider = ImageProvider()
    
    var routing: MainRouter?
    
    var filters = BehaviorRelay<[Filter: Int]>(value: [Filter: Int]())
    
    var filtersArray = [Filter: Int]()
    
    let dispose = DisposeBag()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
    }
}

//MARK: - Init
extension SearchController {
    
    convenience init(_ router: MainRouter) {
        
        self.init()
        
        self.routing = router
    }
}

//MARK: - Actions
extension SearchController {
    @IBAction func blurChange(sender: UISlider!) {
        
        self.filtersArray[Filter.blur] = self.blurSwitch.isOn ? 10 : 0
        self.filters.accept(self.filtersArray)
    }
    
    @IBAction func sepiaChange() {
        
        self.filtersArray[Filter.sepia] = self.sepiaSwitch.isOn ? 1 : 0
        self.filters.accept(self.filtersArray)
    }
    
    @IBAction func monochromeChange() {
        
        self.filtersArray[Filter.crystalize] = self.monochromeSwitch.isOn ? 10 : 0
        self.filters.accept(self.filtersArray)
    }
    
    //MARK: - Request search text
    func fetchSearchImages() {
        
        pageCount+=1   //Count increment here
        
        router.requestFor(text: searchBar.text ?? "", with: pageCount.description, decode: { json -> Photos? in
            guard let flickerResult = json as? Photos else { return  nil }
            return flickerResult
        }) { [unowned self] result in
            
            DispatchQueue.main.async {
                self.labelLoading.text = ""
                switch result{
                case .success(let value):
                    self.updateSearchResult(with: value.photos.photo)
                case .failure(let error):
                    print(error.debugDescription)
                    guard self.router.requestCancelStatus == false else { return }
                    self.showAlertWithError((error?.localizedDescription) ?? "Please check your Internet connection or try again.", completionHandler: {[unowned self] status in
                        guard status else { return }
                        self.fetchSearchImages()
                    })
                }
            }
        }
    }
}

//MARK: - Configure
extension SearchController {
    
    override func configure() {
       
        super.configure()
        
        self.collectionResult.register(ImageCell.nib(), forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        self.searchBar.delegate = self
        self.collectionResult.delegate = self
        self.collectionResult.dataSource = self
        
        self.sepiaSwitch.setOn(false, animated: false)
        self.monochromeSwitch.setOn(false, animated: false)
        self.blurSwitch.setOn(false, animated: false)
        self.blurSlider.setValue(0, animated: false)
        
        self.filters.accept(filtersArray)
    }
    
}

//MARK: - SearchBar Delegate
extension SearchController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        self.resetValuesForNewSearch()
        
        guard let text = searchBar.text?.removeSpace, text.count != 0  else {
            
            self.labelLoading.text = "Please type keyword to search result."
            return
        }
        
        self.fetchSearchImages()
        
        labelLoading.text = "Searching Images..."
    }
    
}

//MARK: - Helpers
extension SearchController {
    
    ////MARK: - Handle response result
    func updateSearchResult(with photo: [Photo]) {
        
        DispatchQueue.main.async { [unowned self] in
            
            self.searchPhotos = photo//.append(contentsOf: newItems)
            self.collectionResult.reloadData()
        }
    }
    
    ////MARK: - Clearing here old data search results with current running tasks
    func resetValuesForNewSearch(){
        pageCount = 0
        router.cancelTask()
        searchPhotos.removeAll()
        collectionResult.reloadData()
    }
}

//MARK: - Collection View DataSource
extension SearchController: UICollectionViewDataSource, RequestImages{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.searchPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
        
        guard searchPhotos.count != 0 else {
            return cell
        }
        
        let model = self.searchPhotos[indexPath.row]
        guard let mediaUrl = model.getImagePath() else {
            return cell
        }
        
        cell.imageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        self.imageProvider.requestImage(from: mediaUrl, completion: { (image) -> Void in
            
            let indexPath_ = collectionView.indexPath(for: cell)
            if indexPath == indexPath_ {
                
                self.add(filters: self.filters.value, to: image) { (filteredImage) in
                    
                    cell.imageView.image = filteredImage
                }
            }
        })
        
        self.filters.subscribe { (value) in
            
            guard let url = self.searchPhotos[indexPath.row].getImagePath() else {
                
                return
            }
            let savedImage = self.imageProvider.cache.object(forKey: url as NSURL)
            self.add(filters: self.filtersArray, to: savedImage) { (image) in
                
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }
        }.disposed(by: cell.dispose)
        
        return cell
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

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionWidth = collectionView.bounds.width;
        var itemWidth = collectionWidth / 3 - 1;
        
        if(UI_USER_INTERFACE_IDIOM() == .pad) {
            itemWidth = collectionWidth / 4 - 1;
        }
        return CGSize(width: itemWidth, height: itemWidth);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
}

//MARK: - Scrollview Delegate
extension SearchController: UIScrollViewDelegate {
    
    //TODO: - PagePagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        if scrollView == collectionResult{
        //            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height)){
        //
        //                //Start locading new data from here
        //                fetchSearchImages()
        //            }
        //        }
    }
}
