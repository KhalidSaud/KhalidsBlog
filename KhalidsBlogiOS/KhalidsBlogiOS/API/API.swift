//
//  API.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 22/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

class API {
    
    let BlogsApiUrl = "https://myblogapi.khalidsaud.com/api/blogs"
    let ImagesApiUrl = "https://myblogapi.khalidsaud.com/api/image"
    

    class func getBlog(completions: @escaping ([Blog?], Error?) -> Void) {
        let request = URLRequest(url: URL(string: API.init().BlogsApiUrl)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completions([], error)
                return
            }
            
            guard let data = data else {
                debugPrint("No Data")
                completions([], error)
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode([Blog].self, from: data)
//                debugPrint("Results here")
//                debugPrint(String(data: data, encoding: .utf8))
                completions(responseObject, nil)
            } catch {
                debugPrint(error)
                completions([], error)
                return
            }
            
        }
        task.resume()
    }
    
    // TODO: Post
    class func postBlog(blog: BlogToSend,completions: @escaping (Blog?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: API.init().BlogsApiUrl)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(blog)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completions(nil, error)
                return
            }
            
            guard let data = data else {
                debugPrint("No Data")
                completions(nil, error)
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(Blog.self, from: data)
                debugPrint("Results here")
                debugPrint(String(data: data, encoding: .utf8))
                completions(responseObject, nil)
            } catch {
                debugPrint(error)
                completions(nil, error)
                return
            }
            
        }
        task.resume()
    }
    
    // TODO: Put
    class func putBlog(blog: Blog,completions: @escaping (Blog?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "\(API.init().BlogsApiUrl)/\(blog.id)")!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(blog)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completions(nil, error)
                return
            }
            
            guard let data = data else {
                debugPrint("No Data")
                completions(nil, error)
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(Blog.self, from: data)
                debugPrint("Results here")
                debugPrint(String(data: data, encoding: .utf8))
                completions(responseObject, nil)
            } catch {
                debugPrint("do catch error")
                completions(nil, error)
                return
            }
            
        }
        task.resume()
    }
    
    // TODO: Delete
    class func deleteBlog(blog: Blog,completions: @escaping (Blog?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "\(API.init().BlogsApiUrl)/\(blog.id)")!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try! JSONEncoder().encode(blog)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completions(nil, error)
                return
            }
            
            guard let data = data else {
                debugPrint("No Data")
                completions(nil, error)
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(Blog.self, from: data)
                debugPrint("Results here")
                debugPrint(String(data: data, encoding: .utf8))
                completions(responseObject, nil)
            } catch {
                debugPrint(error)
                completions(nil, error)
                return
            }
            
        }
        task.resume()
    }
    
    // TODO: Get User for login
    
    // MARK: Get Image
    
    class func getImages(imageName: String, completions: @escaping (UIImage?, Error?) -> Void) {
        let url = API.init().ImagesApiUrl + "/" + imageName
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completions(nil, error)
                return
            }
            
            guard let data = data else {
                debugPrint("No Data")
                completions(nil, error)
                return
            }
            
            do {
//                debugPrint(String(data: data, encoding: .utf8))
                let image = UIImage(data: data)
                completions(image, nil)
            } catch {
                debugPrint(error)
                completions(nil, error)
                return
            }
            
        }
        task.resume()
    }
    
}
