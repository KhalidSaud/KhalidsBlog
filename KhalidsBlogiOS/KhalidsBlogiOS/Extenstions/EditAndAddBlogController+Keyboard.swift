//
//  EditAndAddBlogController+Keyboard.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 28/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

extension EditAndAddBlogController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if titleTextBox.isFirstResponder {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if titleTextBox.isFirstResponder {
            return
        }
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
