//
//  DetailedBlogController.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 24/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

class DetailedBlogController: UIViewController {

   
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var content: UITextView!
    
    var titleHolder = ""
    var imageHolder:UIImage = UIImage(named: "default_image")!
    var contentHolder = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleView.text = titleHolder
        imageView.image = imageHolder
        content.text = contentHolder
    }
    
}
