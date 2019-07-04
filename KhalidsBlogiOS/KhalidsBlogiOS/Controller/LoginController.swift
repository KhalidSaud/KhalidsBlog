//
//  ViewController.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 21/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

class Login: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func LoginButtonPressed(_ sender: Any) {
        
        if !validateFields() {
            showAlert(title: "Error", message: "Please fill all fields!")
            return
        }
        
        getUser()
//        self.navigationController?.popToRootViewController(animated: true)
        
        
    }
    
    func validateFields() -> Bool {
        
        if emailTextField.text == "" {
            debugPrint("Title is emtpy")
            return false
        }
        
        if passwordTextField.text == "" {
            debugPrint("Content is emtpy")
            return false
        }
        
        return true
        
    }
    
    func getUser() {
    
        let userToSend = UserToSend(email: emailTextField.text!, password: passwordTextField.text!)
        
        API.getUser(userToSend: userToSend) { (user, error) in
            if error != nil {
                debugPrint(error!.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                }
                return
            }
            
            guard let user = user else {
                return
            }
                        
            let userDefaults = UserDefaults.standard
            userDefaults.set(user.email, forKey: "email")
            userDefaults.set(user.password, forKey: "password")
            userDefaults.synchronize()
            
            
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            
        }
        
    }
    
}

