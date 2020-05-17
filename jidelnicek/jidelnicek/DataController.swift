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
    

	//nastavení MOC
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
    
}
