//
//  DataController.swift
//  jidelnicek
//
//  Created by Hynek Bernard on 12/05/2020.
//  Copyright © 2020 Hynek Bernard. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {
    

    lazy var persistentContainer: NSPersistentContainer={
        let container = NSPersistentContainer(name: "CDModel")
        container.loadPersistentStores{ description,error in
            if let error = error{
                //CHYBA
            }
        }
        return container
    }()
    func getMOC() -> NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    //public var managedObjectContext: NSManagedObjectContext
    /*init(completionClosure: @escaping () -> ()) {
        
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        guard let modelURL = Bundle.main.url(forResource: "CDModel", withExtension: "momd")
            else{
                return
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            return
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext.persistentStoreCoordinator = psc
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        queue.async {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                return
            }
            let storeURL = docURL.appendingPathComponent("CDModel.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at:storeURL, options: nil)
                DispatchQueue.main.sync(execute:completionClosure)
            }catch{
                
            }
        
        }
        
    }*/
    /*init(completionClosure: @escaping() -> ()) {
        self.persistentContainer = NSPersistentContainer(name:"CDModel")
        persistentContainer.loadPersistentStores() {(description, error) in if let error = error {fatalError("let me die pls \(error)")}
            completionClosure()
        }
    }*/
}
