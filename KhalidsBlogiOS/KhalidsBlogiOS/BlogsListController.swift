//
//  BlogsListController.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 21/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

class BlogsListController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ToBlogButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ToBlog", sender: nil)
    }
    
    @IBAction func LoginButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ToLogin", sender: nil)
    }


}
