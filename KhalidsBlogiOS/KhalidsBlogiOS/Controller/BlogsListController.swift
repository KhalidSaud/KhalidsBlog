//
//  BlogsListController.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 21/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit
import CoreData

class BlogsListController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var x = 1
    
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
    
    
    var fetchController: NSFetchedResultsController<BlogsModel2>!
//    var pin: Pin!
    var pageNum = 1
    var DeleteEverything = false
    
    var managedObjectContext: NSManagedObjectContext {
        return DataController.dataController.viewContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIfLoggedIn()
        setupAccess()
        setupFetchController()
        displayActivityIndicator(shouldDisplay: true)
        getListFromApi()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    
    func checkIfLoggedIn() {
        if (UserDefaults.standard.string(forKey: "email") != nil && UserDefaults.standard.string(forKey: "password") != nil) {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
    
    func setupAccess() {
        if isLoggedIn {
            loginButton.title = "Log Out"
            addButton.isEnabled = true
            refreshButton.isEnabled = true
        } else {
            loginButton.title = "Log In"
            addButton.isEnabled = false
            refreshButton.isEnabled = false
        }
    }
    
    @IBAction func LoginButtonPressed(_ sender: Any) {
        
        
        if !isLoggedIn {
            performSegue(withIdentifier: "ToLogin", sender: nil)
        } else {
            // MARK: logout
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "password")
            isLoggedIn = false
            setupAccess()
            tableView.reloadData()
        }
        
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        editingMode = false
        performSegue(withIdentifier: "ListToEditAndAddView", sender: nil)
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {

        setupFetchController()

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
    
    
    func updateTableFromBlogsModel() {
        isLoggedIn = false
        setupAccess()
        
        blogs = []
        
        let fetchRequest: NSFetchRequest<BlogsModel2> = BlogsModel2.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchController.delegate = self
        do {
            try fetchController.performFetch()
            if checkIfThereIsBlogsInModel() {
                
                let blogs = fetchController.fetchedObjects
                for blog in blogs! {
                    if blog.title != nil {
                        self.blogs.append(Blog(id: Int(blog.id), title: blog.title!, imageName: blog.imageName, content: blog.content!))
                        self.images[Int(blog.id)] = UIImage(data: blog.image!)
                    }
                }
                self.tableView.reloadData()
                
            } else {
                debugPrint("no data")
            }
        } catch {
            fatalError("Photos fetch error : \(error.localizedDescription)")
        }
        
    }
    
    
    
    func getListFromApi() {
        
        checkIfLoggedIn()
        setupAccess()
        
        tempBlogs = []
        self.displayActivityIndicator(shouldDisplay: true)
        
        API.getBlog { (blogs, error) in
            
            if error != nil {
                debugPrint(error!.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                    self.displayActivityIndicator(shouldDisplay: false)
                    // TODO : update from model
                    self.updateTableFromBlogsModel()
                }
                return
            }
            
            for blog in blogs {
                
                self.tempBlogs.append(blog!)
                
                
                
                self.deleteModelData()
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
                    self.addBlogs(blog: blog, image: UIImage(named: "default_image")!)
                    self.tableView.reloadData()
                    if self.images.count == self.countToStopIndicator {
                        self.displayActivityIndicator(shouldDisplay: false)
                    }
                }
                return
            }
            
            guard let image = image else {
                DispatchQueue.main.async {
                    self.displayActivityIndicator(shouldDisplay: false)
                }
                return
            }
            
            
            DispatchQueue.main.async {
                self.images[blog.id] = image
                self.addBlogs(blog: blog, image: image)
                self.tableView.reloadData()
                if self.images.count == self.countToStopIndicator {
                    self.displayActivityIndicator(shouldDisplay: false)
                }
            }
        }
    }
    
    
    
    
    
    func setupFetchController() {
        let fetchRequest: NSFetchRequest<BlogsModel2> = BlogsModel2.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchController.delegate = self
        do {
            try fetchController.performFetch()
            if checkIfThereIsBlogsInModel() {

                let blogs = fetchController.fetchedObjects
                for blog in blogs! {
                    if blog.title != nil {
                        // debugPrint("\(blog.id) \(blog.title) \(blog.content) \(blog.imageName) \(blog.image)")
                    }
                }
                
            } else {
                debugPrint("no data")
            }
        } catch {
            fatalError("Photos fetch error : \(error.localizedDescription)")
        }
    }
    
    func addBlogs(blog: Blog, image: UIImage) {
        
        let blogsMoldel = BlogsModel2(context: self.managedObjectContext)
        let fetchedBlogsModel = self.fetchController.fetchedObjects
        var isDuplicate = false
        
        if !fetchedBlogsModel!.isEmpty {
            for fetchedBlog in fetchedBlogsModel! {
                if fetchedBlog.id == Int64(blog.id) {
                    isDuplicate = true
                }
            }
        } else {
            blogsMoldel.id = Int64(blog.id)
            blogsMoldel.title = blog.title
            blogsMoldel.imageName = blog.imageName
            blogsMoldel.content = blog.content
            blogsMoldel.image = image.jpegData(compressionQuality: 1)
            try? self.managedObjectContext.save()
        }
        
        
        if !isDuplicate {
            blogsMoldel.id = Int64(blog.id)
            blogsMoldel.title = blog.title
            blogsMoldel.imageName = blog.imageName
            blogsMoldel.content = blog.content
            blogsMoldel.image = image.jpegData(compressionQuality: 1)
            try? self.managedObjectContext.save()
        } else {
            updateModel(blog: blog, image: image)
        }
        
    }
    
    func updateModel(blog: Blog, image: UIImage) {
        let fetchRequest: NSFetchRequest<BlogsModel2> = BlogsModel2.fetchRequest()
        fetchController.delegate = self
        fetchRequest.predicate = NSPredicate(format: "id == \(blog.id)")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchController.performFetch()
            if checkIfThereIsBlogsInModel() {
                
                let blogs = fetchController.fetchedObjects
                for fetchedBlog in blogs! {
                    if blog.title != nil {
                        fetchedBlog.id = Int64(blog.id)
                        fetchedBlog.title = blog.title
                        fetchedBlog.imageName = blog.imageName
                        fetchedBlog.content = blog.content
                        fetchedBlog.image = image.jpegData(compressionQuality: 1)
                        try? self.managedObjectContext.save()
                        
                    }
                }
                setupFetchController()
                
            } else {
                debugPrint("no data")
            }
        } catch {
            fatalError("Photos fetch error : \(error.localizedDescription)")
        }
    }
    
    func deleteModelData() {

        if checkIfThereIsBlogsInModel() {
            debugPrint("deleting model data")
            for blog in fetchController.fetchedObjects! {
                managedObjectContext.delete(blog)
            }
            
            try? managedObjectContext.save()
            setupFetchController()
        } else {
            debugPrint("no model")
        }
    }
    
    func checkIfThereIsBlogsInModel() -> Bool {
        return (fetchController.fetchedObjects?.count ?? 0) != 0
    }

}
