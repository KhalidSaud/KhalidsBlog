//
//  BlogsListController.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 21/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

class BlogsListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dummyData:[String] = ["test 1", "test 2", "test 3"]
    var blogs:[Blog] = []
    var images:[Int:UIImage] = [:]
    
    var idHolder = 0
    var titleHolder = ""
    var imageHolder = UIImage(named: "default_image")
    var contentHolder = ""
    var editingMode = false

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // TODO: isLoogedIn hide show change labels
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getListFromApi()
    }

    
    @IBAction func LoginButtonPressed(_ sender: Any) {
        let isLoggedIn = true
        
        if isLoggedIn {
            performSegue(withIdentifier: "ToLogin", sender: nil)
        } else {
            // logout
        }
        
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        editingMode = false
        performSegue(withIdentifier: "ListToEditAndAddView", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
        if segue.identifier == "ToBlog" {
            if let detailedBlogController = segue.destination as? DetailedBlogController {
                
                var indexPath: NSIndexPath = self.tableView!.indexPathForSelectedRow as! NSIndexPath
                
                do {
                    detailedBlogController.titleHolder = blogs[indexPath.row].title
                    detailedBlogController.imageHolder = images[blogs[indexPath.row].id]!
                    detailedBlogController.contentHolder = blogs[indexPath.row].content
                } catch {
                    debugPrint("ToBlog segue error")
                }
            }
        }
        
        if segue.identifier == "ListToEditAndAddView" {

            if let editAndAddVC = segue.destination as? EditAndAddBlogController {
                
                do {
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
                    
                    
                } catch {
                    debugPrint("ToBlog segue error")
                }
            }
        }
        
    }
    
    
    func getListFromApi() {
        blogs = []
        images = [:]
        
        API.getBlog { (blogs, error) in
            if error != nil {
                debugPrint("error in login button \(String(describing: error))")
                return
            }
            
            for blog in blogs {
                
                self.blogs.append(blog!)
                
                API.getImages(imageName: blog?.imageName ?? "") { (image, error) in
                    
                    guard let blog = blog else {
                        return
                    }
                    
                    if image == nil {
                        self.images[blog.id] = UIImage(named: "default_image")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        return
                    }
                    
                    guard let image = image else {
                        debugPrint("image issue")
                        
                        return
                    }
                    
                    self.images[blog.id] = image
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func deleteBlog(id: Int, blogToDelete: Blog) {
        API.deleteBlog(blog: blogToDelete) { (blog, error) in
            if error != nil {
                debugPrint(error?.localizedDescription)
            }
            
            // TODO : Notify User
            debugPrint("Blog Deleted!")
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        
        cell.textLabel?.text = blogs[indexPath.row].title
        cell.imageView?.image = images[blogs[indexPath.row].id]
        cell.detailTextLabel?.text = "secondray text"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToBlog", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let update = UIContextualAction(style: .normal, title: "Update") { (action, view, completion) in
            self.idHolder = self.blogs[indexPath.row].id
            self.titleHolder = self.blogs[indexPath.row].title
            self.imageHolder = self.images[self.blogs[indexPath.row].id]
            self.contentHolder = self.blogs[indexPath.row].content
            self.editingMode = true
            self.performSegue(withIdentifier: "ListToEditAndAddView", sender: nil)
            completion(true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            debugPrint("Delete")
            // TODO: deleteBlog()
            
            let blogToDelete = Blog(id: self.blogs[indexPath.row].id, title: self.blogs[indexPath.row].title, imageName: self.blogs[indexPath.row].imageName, content: self.blogs[indexPath.row].content)
            self.deleteBlog(id: blogToDelete.id, blogToDelete: blogToDelete)
            
            completionHandler(true)
        }
        
        let isLoggedIn = true
        let swipeAction:UISwipeActionsConfiguration
        
        if isLoggedIn == true {
            swipeAction = UISwipeActionsConfiguration(actions: [update, delete])
        } else {
            swipeAction = UISwipeActionsConfiguration(actions: [])
        }
        
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }


}
