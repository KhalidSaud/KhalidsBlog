//
//  BlogsListController+UITableView.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 28/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

extension BlogsListController: UITableViewDelegate, UITableViewDataSource {
    
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
        performSegue(withIdentifier: "ToBlog", sender: indexPath)
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
            
            let blogToDelete = Blog(id: self.blogs[indexPath.row].id, title: self.blogs[indexPath.row].title, imageName: self.blogs[indexPath.row].imageName, content: self.blogs[indexPath.row].content)
            
            let alert = UIAlertController(title: "Delete ?", message: "Are you sure you want to delete this blog ?", preferredStyle: .alert)
            let actionDelete = UIAlertAction(title: "delete!", style: .destructive, handler: { (action) in

                API.deleteBlog(blog: blogToDelete) { (blog, error) in
                    if error != nil {
                        debugPrint(error?.localizedDescription as Any)
                        DispatchQueue.main.async {
                            self.showAlert(title: "Error", message: error!.localizedDescription)
                        }
                        return
                    }
                    debugPrint("Blog Deleted!")
                    DispatchQueue.main.async {
                        self.showAlert(title: "Deleted!", message: "Blog Deleted Successfully!")
                        completionHandler(true)
                    }
                }
            })
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(actionDelete)
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
            
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
    
    // MARK: Delete blog from API database
    func deleteBlog(id: Int, blogToDelete: Blog) {
//        API.deleteBlog(blog: blogToDelete) { (blog, error) in
//            if error != nil {
//                debugPrint(error?.localizedDescription as Any)
//                DispatchQueue.main.async {
//                    self.showAlert(title: "Error", message: error!.localizedDescription)
//                }
//            }
//            debugPrint("Blog Deleted!")
//            DispatchQueue.main.async {
//                self.showAlert(title: "Deleted!", message: "Blog Deleted Successfully!")
//            }
//        }
    }
    
}
