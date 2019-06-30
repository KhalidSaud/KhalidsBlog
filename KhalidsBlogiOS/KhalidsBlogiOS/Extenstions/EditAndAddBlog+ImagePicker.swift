//
//  EditAndAddBlog+ImagePicker.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 28/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

extension EditAndAddBlogController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
}
