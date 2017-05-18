//
//  Event.swift
//  sownata
//
//  Created by Gary Joy on 23/03/2017.
//
//

import CoreData

class Event: NSManagedObject {

    override var description: String {
        
        return "\(String(describing: self.primaryNoun!.name!)) \(String(describing: self.verb!.name!))"
    }

}

