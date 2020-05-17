//
//  Den.swift
//  jidelnicek
//
//  Created by Hynek Bernard on 11/05/2020.
//  Copyright © 2020 Hynek Bernard. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class Den : NSManagedObject{
	//mazání položek dne
    func clear(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let moc = appDelegate.dataController.getMOC()
        if snidane != nil {
            moc.delete(snidane!)
            snidane = nil
        }
        if obed != nil {
            moc.delete(obed!)
            obed = nil
        }
        if vecere != nil {
            moc.delete(vecere!)
            vecere = nil
        }
    }
}


