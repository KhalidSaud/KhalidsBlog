//
//  EditAndAddBlogController.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 24/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

class EditAndAddBlogController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var editingMode = false
    
    var idHolder = 0
    var titleHolder = ""
    var imageHolder = UIImage(named: "default_image")
    var contentHolder = ""
    
    @IBOutlet weak var titleTextBox: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextBox: UITextField!
    
    @IBOutlet weak var addBlogButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        imagePicker.delegate = self
        
        titleTextBox.text = titleHolder
        imageView.image = imageHolder
        contentTextBox.text = contentHolder

        if editingMode {
            addBlogButton.title = "Update Blog"
        } else {
            addBlogButton.title = "Add Blog"
        }
        
    }
    
    @IBAction func uploadImageButtonPressed(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
        
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            
            DispatchQueue.main.async {
                self.imageView.image = pickedImage
                self.imageView.setNeedsDisplay()
            }
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func addAndUpdateButtonPressed(_ sender: Any) {
        
        if titleTextBox.text == "" {
            debugPrint("Title is emtpy")
            return
        }
        
        if contentTextBox.text == "" {
            debugPrint("Content is emtpy")
            return
        }
        
        var image = self.imageView.image
        
        if image == nil {
            image = UIImage(named: "default_image")
        }
        
        if !editingMode {
            // TODO : Post Api
            let blog = BlogToSend(title: titleTextBox.text!, imageName: "", content: contentTextBox.text!)
            
            API.postBlog(blog: blog) { (blog, error) in
                if error != nil {
                    debugPrint(error?.localizedDescription as Any)
                    return
                }
                
                guard let blog = blog else {
                    debugPrint("guard issue")
                    return
                }
                
                debugPrint(blog)
                
//                API.init().imageUploadRequest(image: image!, blogId: blog.id, param: nil, completion: (Bool, Error?) -> Void)
                API.init().imageUploadRequest(image: image!, blogId: blog.id, param: nil, completion: { (boolImage, error) in
                    if error != nil {
                        debugPrint(error?.localizedDescription as Any)
                        return
                    }
                    
                    if boolImage == false {
                        debugPrint("Image Not Found To upload")
                        return
                    } else {
                        
                        debugPrint("Image uploaded")
                        
                        // TODO : Go To List
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                    }
                    
                })

                
            }
        } else {
            // TODO : Put Api
            let blogToUpdate = Blog(id: idHolder, title: titleTextBox.text!, imageName: "", content: contentTextBox.text!)
            
            API.putBlog(blog: blogToUpdate) { (blog, error) in
                if error != nil {
                    debugPrint(error?.localizedDescription as Any)
                }
                
                // TODO : Upload Current or New Image
//                API.init().imageUploadRequest(image: image!, blogId: blogToUpdate.id, param: nil)
                API.init().imageUploadRequest(image: image!, blogId: blogToUpdate.id, param: nil, completion: { (boolImage, error) in
                    if error != nil {
                        debugPrint(error?.localizedDescription as Any)
                        return
                    }
                    
                    if boolImage == false {
                        debugPrint("Image Not Found To upload")
                        return
                    } else {
                        
                        debugPrint("Blog and Image uploaded")
                        
                        // TODO : Go To List
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                    
                })

            }
        }
        
    }
    
}
