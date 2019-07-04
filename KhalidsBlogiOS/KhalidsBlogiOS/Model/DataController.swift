//
//  DataController.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 02/07/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let dataController = DataController()
    
    let persistentDataContainer = NSPersistentContainer(name: "BlogsModel")
    
    var viewContext: NSManagedObjectContext {
        return persistentDataContainer.viewContext
    }
    
    func load() {
        persistentDataContainer.loadPersistentStores { (storeDesc, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
    
}
