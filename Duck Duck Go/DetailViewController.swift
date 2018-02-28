//
//  DetailViewController.swift
//  Duck Duck Go
//
//  Created by Parthiban on 2/28/18.
//  Copyright © 2018 Ossum. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    var resultItem = SearchResultModel()

    func configureView() {
        
        imageView.image = UIImage(named: "placeholder")

        if let resImage = resultItem.iconURL {
            //get image here and set in view
        }
        else {
            imageView.image = UIImage(named: "placeholder")
        }
        
        if let textVal = resultItem.text {
            textView.text = textVal
        }
        
        if let titleVal = resultItem.title {
            self.title = titleVal
        }
        
        if let imageURL = resultItem.iconURL {
            
            let plcHldrImg = UIImage(named: "placeholder")

            if let builtUrl = URL.init(string: imageURL) {
                
                let resource = ImageResource(downloadURL: builtUrl, cacheKey: imageURL)
                imageView.kf.setImage(with: resource, placeholder: plcHldrImg, options: [.targetCache(Utility.sharedInstance.userMediaCache),.cacheMemoryOnly], progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    
                    if let err = error {
                        dLog("error in downloading profile image : \(err)")
                        
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(named: "placeholder")
                        }
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                        
                        
                    }
                    
                    
                })
            }
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

