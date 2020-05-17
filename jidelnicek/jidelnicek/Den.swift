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
    /*@NSManaged var datum: Date
    @NSManaged var snidane: Jidlo?
    @NSManaged var obed: Jidlo?
    var vecere: Jidlo?
    init(datum: Date) {
        self.datum = datum
    }*/
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
    var worthSaving: Bool{
        get{
            if snidane != nil || obed != nil || vecere != nil{
                return true
            }
            return false
        }
    }
}


