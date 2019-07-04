//
//  EditAndAddBlogController.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 24/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

class EditAndAddBlogController: UIViewController {

    // MARK: Variables
    var editingMode = false
    
    var idHolder = 0
    var titleHolder = ""
    var imageHolder = UIImage(named: "default_image")
    var contentHolder = ""
    
    let imagePicker = UIImagePickerController()
    
    // MARK: Outlets
    @IBOutlet weak var titleTextBox: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextBox: UITextView!
    
    @IBOutlet weak var addBlogButton: UIBarButtonItem!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: Setup controller and views
    func setup() {
        titleTextBox.text = titleHolder
        imageView.image = imageHolder
        contentTextBox.text = contentHolder
        
        let borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 204.0/255.0)
        contentTextBox.layer.borderColor = borderColor.cgColor;
        contentTextBox.layer.borderWidth = 1.0;
        contentTextBox.layer.cornerRadius = 5.0;
        
        imagePicker.delegate = self
        
        if editingMode {
        addBlogButton.title = "Update Blog"
        } else {
        addBlogButton.title = "Add Blog"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Choose image from gallery and assign it to imageView (not uploaded to api yet)
    @IBAction func uploadImageButtonPressed(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Main add/update button to API database.
    @IBAction func addAndUpdateButtonPressed(_ sender: Any) {
        
        if !validateFields() {
            showAlert(title: "Error", message: "Please all fields")
            return
        }
        
        if !editingMode {
            // MARK: Post Api
            displayActivityIndicator(shouldDisplay: true)
            addBlog()
        } else {
            // MARK: Put Api
            displayActivityIndicator(shouldDisplay: true)
            updateBlog()
        }
    }
    
    
    func validateFields() -> Bool {
        
        if titleTextBox.text == "" {
            debugPrint("Title is emtpy")
            return false
        }
        
        if contentTextBox.text == "" {
            debugPrint("Content is emtpy")
            return false
        }
        
        var image = self.imageView.image
        if image == nil { image = UIImage(named: "default_image") }
        
        return true
        
    }
    
    // MARK: Add blog to API database.
    func addBlog() {
        
        let blog = BlogToSend(title: titleTextBox.text!, imageName: "", content: contentTextBox.text!)
        let image = self.imageView.image
        
        API.postBlog(blog: blog) { (blog, error) in
            if error != nil {
                debugPrint(error?.localizedDescription as Any)
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                }
                return
            }
            
            guard let blog = blog else {
                return
            }
                        
            API.init().imageUploadRequest(image: image!, blogId: blog.id, param: nil, completion: { (boolImage, error) in
                if error != nil {
                    debugPrint(error?.localizedDescription as Any)
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: error!.localizedDescription)
                    }
                    return
                }
                if boolImage == false {
                    debugPrint("Image Not Found To upload")
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: "Image Not Found")
                    }
                    return
                } else {
                    debugPrint("Image uploaded")
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            })
        }
    }
    
    // MARK: Update blog in API database.
    func updateBlog() {
        
        let blogToUpdate = Blog(id: idHolder, title: titleTextBox.text!, imageName: "", content: contentTextBox.text!)
        let image = self.imageView.image!
        
        API.putBlog(blog: blogToUpdate) { (blog, error) in
            if error != nil {
                debugPrint(error?.localizedDescription as Any)
                DispatchQueue.main.async {
                    self.displayActivityIndicator(shouldDisplay: false)
                }
            }
  
            
            API.init().imageUploadRequest(image: image, blogId: blogToUpdate.id, param: nil, completion: { (boolImage, error) in
                if error != nil {
                    debugPrint(error?.localizedDescription as Any)
                    DispatchQueue.main.async {
                        self.displayActivityIndicator(shouldDisplay: false)
                    }
                    return
                }
                
                if boolImage == false {
                    debugPrint("Image Not Found To upload")
                    DispatchQueue.main.async {
                        self.displayActivityIndicator(shouldDisplay: false)
                    }
                    return
                } else {
                    
                    debugPrint("Blog and Image uploaded")
                    DispatchQueue.main.async {
                        self.displayActivityIndicator(shouldDisplay: false)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            })
        }
    }
}
