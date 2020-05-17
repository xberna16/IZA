//
//  Jidlo.swift
//  jidelnicek
//
//  Created by Hynek Bernard  on 11/05/2020.
//  Copyright © 2020 Hynek Bernard. All rights reserved.
//

import Foundation
import UIKit
import CoreData
enum typJidla: String {
    case Snidane = "Snídaně"
    case Obed = "Oběd"
    case Vecere = "Večeře"
}

class Jidlo: NSManagedObject {
    
    /*@NSManaged var nazev: String
    @NSManaged var suroviny: String
    //var typ: typJidla
    init(nazev: String, suroviny: String/*, typ:typJidla*/) {
        self.nazev = nazev
        self.suroviny = suroviny
        //self.typ = typ
    }*/
}

