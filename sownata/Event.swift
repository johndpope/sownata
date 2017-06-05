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
        
        var eventDescription = "On \(String(describing: self.month!)) \(String(describing: self.primaryNoun!.name!)) \(String(describing: self.verb!.name!))"
        
        if (self.secondaryNoun != nil) {
            eventDescription = "\(eventDescription) \(self.secondaryNoun!.name!)"
        }

        if (self.attributes != nil && (self.attributes?.count)! > 0) {
            let attributes = self.attributes?.allObjects as! [Attribute]
            for attribute in attributes {
                eventDescription = "\(eventDescription) \(attribute.property!.name!)=\(attribute.attribute!)"
            }
        }

        if (self.values != nil && (self.values?.count)! > 0) {
            let values = self.values?.allObjects as! [Value]
            for value in values {
                eventDescription = "\(eventDescription) \(value.measure!.name!)=\(value.value!)"
            }
        }

        return eventDescription
    }
    
    public func setTime(time: NSDate) {
        self.time = time
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM.yyyy"
        self.month = monthFormatter.string(from: time as Date)

        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        self.year = yearFormatter.string(from: time as Date)
    }

}

