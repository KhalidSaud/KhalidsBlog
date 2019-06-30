//
//  BlogsListController.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 21/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

class BlogsListController: UIViewController {
    
    var isLoggedIn = false
    
    var dummyData:[String] = ["test 1", "test 2", "test 3"]
    var blogs:[Blog] = []
    var tempBlogs:[Blog] = []
    var images:[Int:UIImage] = [:]
    
    var countToStopIndicator = 0
    
    var idHolder = 0
    var titleHolder = ""
    var imageHolder = UIImage(named: "default_image")
    var contentHolder = ""
    var editingMode = false

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        checkIfLoggedin()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getListFromApi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayActivityIndicator(shouldDisplay: true)
    }

    func checkIfLoggedin() {

        // TODO : user defaults
        let username = "1"
        let password = "1"
        
        if !username.isEmpty && !password.isEmpty {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
        
        setupAccess()
    }
    
    func setupAccess() {
        if isLoggedIn {
            loginButton.title = "Log in"
            addButton.isEnabled = true
            refreshButton.isEnabled = true
        } else {
            loginButton.title = "Log Out"
            addButton.isEnabled = false
            refreshButton.isEnabled = false
        }
    }
    
    @IBAction func LoginButtonPressed(_ sender: Any) {
        
        
        if isLoggedIn {
            performSegue(withIdentifier: "ToLogin", sender: nil)
        } else {
            // TODO: logout
            
        }
        
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        editingMode = false
        performSegue(withIdentifier: "ListToEditAndAddView", sender: nil)
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        getListFromApi()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
        if segue.identifier == "ToBlog" {
            if let detailedBlogController = segue.destination as? DetailedBlogController {
                
                let indexPath = sender as! IndexPath
                detailedBlogController.titleHolder = blogs[indexPath.row].title
                if images[blogs[indexPath.row].id] == nil {
                    detailedBlogController.imageHolder = UIImage(named: "default_image")!
                } else {
                    detailedBlogController.imageHolder = images[blogs[indexPath.row].id]!
                }
                detailedBlogController.contentHolder = blogs[indexPath.row].content
                
            }
        }
        
        if segue.identifier == "ListToEditAndAddView" {

            if let editAndAddVC = segue.destination as? EditAndAddBlogController {
                
                if !editingMode {
                    editAndAddVC.titleHolder = ""
                    editAndAddVC.imageHolder = UIImage(named: "default_image")
                    editAndAddVC.contentHolder = ""
                    editAndAddVC.editingMode = false;
                } else {
                    editAndAddVC.idHolder = idHolder
                    editAndAddVC.titleHolder = titleHolder
                    editAndAddVC.imageHolder = imageHolder
                    editAndAddVC.contentHolder = contentHolder
                    editAndAddVC.editingMode = true;
                }
                
            }
        }
        
    }
    
    
    func getListFromApi() {
        
        tempBlogs = []
        self.displayActivityIndicator(shouldDisplay: true)
        
        API.getBlog { (blogs, error) in
            
            if error != nil {
                debugPrint(error!.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                    self.displayActivityIndicator(shouldDisplay: false)
                }
                return
            }
            
            for blog in blogs {
                
                self.tempBlogs.append(blog!)
                self.getBlogImageFromApi(blog: blog)
                
            }
            
            
            DispatchQueue.main.async {
                self.blogs = self.tempBlogs
                self.countToStopIndicator = self.blogs.count
                self.tableView.reloadData()
            }
        }
    }
    
    func getBlogImageFromApi(blog: Blog?) {
        
        API.getImages(imageName: blog?.imageName ?? "") { (image, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                    self.displayActivityIndicator(shouldDisplay: false)
                }
            }
            
            guard let blog = blog else {
                return
            }
            
            if image == nil {
                
                DispatchQueue.main.async {
                    self.images[blog.id] = UIImage(named: "default_image")
                    self.tableView.reloadData()
                    if self.images.count == self.countToStopIndicator {
                        self.displayActivityIndicator(shouldDisplay: false)
                    }
                }
                return
            }
            
            guard let image = image else {
                return
            }
            
            
            DispatchQueue.main.async {
                self.images[blog.id] = image
                self.tableView.reloadData()
                if self.images.count == self.countToStopIndicator {
                    self.displayActivityIndicator(shouldDisplay: false)
                }
            }
        }
    }

}
