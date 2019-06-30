//
//  UIViewController+ShowAlert.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 28/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
