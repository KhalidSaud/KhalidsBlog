//
//  API.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 22/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

class API : Login {
    
    let BlogsApiUrl = "https://myblogapi.khalidsaud.com/api/blogs"
    let ImagesApiUrl = "https://myblogapi.khalidsaud.com/api/image"
    let UsersApiUrl = "https://myblogapi.khalidsaud.com/api/auth"
    

    // MARK: GetUser
    class func getUser(userToSend: UserToSend ,completions: @escaping (User?, String?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: API.init().UsersApiUrl)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(userToSend)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                debugPrint("error")
                completions(nil, nil, error)
                return
            }
            
            guard let data = data else {
                debugPrint("No Data")
                completions(nil, nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    let message = String(data: data, encoding: .utf8) as! String
                    completions(nil, message, nil)
                    return
                }
            }
            
            do {
                debugPrint("results are here")
                let responseObject = try JSONDecoder().decode(User.self, from: data)
                completions(responseObject, nil, nil)
            } catch {
                debugPrint(error)
                completions(nil, nil, error)
                return
            }
            
        }
        task.resume()
    }
    
    // MARK: GetBlog
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
                completions(responseObject, nil)
            } catch {
                debugPrint(error)
                completions([], error)
                return
            }
            
        }
        task.resume()
    }
    
    // MARK: Post
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
                debugPrint(String(data: data, encoding: .utf8) as Any)
                completions(responseObject, nil)
            } catch {
                debugPrint(error)
                completions(nil, error)
                return
            }
            
        }
        task.resume()
    }
    
    // MARK: Put
    class func putBlog(blog: Blog,completions: @escaping (String?, Error?) -> Void) {
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
            
            completions("Blog updated", nil)
            
        }
        task.resume()
    }
    
    // MARK: Delete
    class func deleteBlog(blog: Blog,completions: @escaping (Blog?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "\(API.init().BlogsApiUrl)/\(blog.id)")!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
                completions(responseObject, nil)
            } catch {
                debugPrint(error.localizedDescription)
                completions(nil, error)
                return
            }
            
        }
        task.resume()
    }
    
    
    
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
    
    // MARK : Post Image

    
    func imageUploadRequest(image: UIImage, blogId: Int, param: [String:String]?, completion: @escaping (Bool, Error?) -> Void) {
        
        let uploadUrl = URL(string: "https://myblogapi.khalidsaud.com/api/blogId/\(blogId)/addImage")!
        
        let request = NSMutableURLRequest(url:uploadUrl);
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        if(imageData == nil)  { completion(false, nil); return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if let data = data {
                        
                        // You can print out response object
                        print("******* response = \(String(describing: response))")
                        
                        print(data.count)
                        
                        completion(true, nil)
                        
                        
                    } else if let error = error {
                        print(error.localizedDescription)
                        completion(false, error.localizedDescription as? Error)
                    }
        })
        task.resume()
        
        
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
    

