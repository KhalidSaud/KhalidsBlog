//
//  EditAndAddBlogController.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 24/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

class EditAndAddBlogController: UIViewController {

    var editingMode = false
    
    var idHolder = 0
    var titleHolder = ""
    var imageHolder = UIImage(named: "default_image")
    var contentHolder = ""
    
    @IBOutlet weak var titleTextBox: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextBox: UITextField!
    
    @IBOutlet weak var addBlogButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleTextBox.text = titleHolder
        imageView.image = imageHolder
        contentTextBox.text = contentHolder

        if editingMode {
            addBlogButton.title = "Update Blog"
        } else {
            addBlogButton.title = "Add Blog"
        }
        
    }
    
    @IBAction func addAndUpdateButtonPressed(_ sender: Any) {
        
        if !editingMode {
            // TODO : Post Api
            let blog = BlogToSend(title: "test", imageName: "", content: "test")
            
            API.postBlog(blog: blog) { (blog, error) in
                if error != nil {
                    debugPrint(error?.localizedDescription)
                    return
                }
                
                guard let blog = blog else {
                    debugPrint("guard issue")
                    return
                }
                
                debugPrint(blog)
                
            }
        } else {
            // TODO : Put Api
            let blogToUpdate = Blog(id: idHolder, title: "Title Updated", imageName: "", content: contentHolder)
            
            API.putBlog(blog: blogToUpdate) { (blog, error) in
                if error != nil {
                    debugPrint(error?.localizedDescription)
                }
                
                // TODO : Upload Current or New Image
                
                // TODO : Notify user
                
                debugPrint("Updated!")
            }
        }
        
    }
    
}
