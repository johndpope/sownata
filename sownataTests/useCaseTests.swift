//
//  useCaseTests.swift
//  useCaseTests
//
//  Created by Gary Joy on 19/04/2016.
//
//

import XCTest

import CoreData

@testable import sownata

@available(iOS 10.0, *)
class useCaseTests: XCTestCase {
    
    // Create a local NSManagedObjectContext
    var managedObjectContext: NSManagedObjectContext? = nil
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EventsModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    override func tearDown() {
        super.tearDown()
        managedObjectContext = nil
    }
    
    override func setUp() {
        super.setUp()
        // Set the NSManagedObjectContext with the view Context
        managedObjectContext = self.persistentContainer.viewContext
        
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        _ = eventsModel.createNoun(id: "horse", name:"Horse")
    }
    

    func testWeighInEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count

        let horseNoun = eventsModel.findNoun(id: "horse")
        
        let weighVerb = eventsModel.createVerb(id: "weigh", name:"weighed")

        let kgMeasure = eventsModel.createMeasure(id: "kg", name: "kg", verb: weighVerb)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        let firstDateString = "01-01-2017 10:00"
        let firstWeight = eventsModel.createValue(valueValue: 95.0, measure: kgMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: firstDateString)!, primaryNoun: horseNoun, verb: weighVerb, value: firstWeight)
    
        let secondDateString = "01-02-2017 10:00"
        let secondWeight = eventsModel.createValue(valueValue: 93.0, measure: kgMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: secondDateString)!, primaryNoun: horseNoun, verb: weighVerb, value: secondWeight)

        let thirdDateString = "01-03-2017 10:00"
        let thirdWeight = eventsModel.createValue(valueValue: 92.0, measure: kgMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: thirdDateString)!, primaryNoun: horseNoun, verb: weighVerb, value: thirdWeight)

        let fourthDateString = "15-03-2017 10:00"
        let fourthWeight = eventsModel.createValue(valueValue: 93.0, measure: kgMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: fourthDateString)!, primaryNoun: horseNoun, verb: weighVerb, value: fourthWeight)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 4)
        
        // TODO:  Make an assertion about my average weight each month...
    }
    
    func testToiletCleaningEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let horseNoun = eventsModel.findNoun(id: "horse")
        
        let cleanVerb = eventsModel.createVerb(id: "clean", name:"cleaned")
        let toiletNoun = eventsModel.createNoun(id: "toilet", name:"the Toilet")
        
        _ = eventsModel.createEvent(primaryNoun: horseNoun, verb: cleanVerb, secondaryNoun: toiletNoun)
        XCTAssert(eventsModel.events?.count == startingEventCount! + 1)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"

        let firstDateString = "01-01-2017 10:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: firstDateString)!, primaryNoun: horseNoun, verb: cleanVerb, secondaryNoun: toiletNoun)

        let secondDateString = "01-02-2017 10:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: secondDateString)!, primaryNoun: horseNoun, verb: cleanVerb, secondaryNoun: toiletNoun)

        let thirdDateString = "01-03-2017 10:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: thirdDateString)!, primaryNoun: horseNoun, verb: cleanVerb, secondaryNoun: toiletNoun)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 4)
        
        // TODO:  Make an assertion about the number of times Horse cleaned the Toilet...
    }
    
    func testRunningEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let horseNoun = eventsModel.findNoun(id: "horse")
        
        let runningVerb = eventsModel.createVerb(id: "run", name:"ran")
        
        let kmMeasure = eventsModel.createMeasure(id: "km", name: "km", verb: runningVerb)
        let minutesMeasure = eventsModel.createMeasure(id: "minutes", name: "minutes", verb: runningVerb)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        let firstDateString = "01-01-2017 10:00"
        let firstDuration = eventsModel.createValue(valueValue: 5.0, measure: kmMeasure)
        let firstDistance = eventsModel.createValue(valueValue: 30, measure: minutesMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: firstDateString)!, primaryNoun: horseNoun, verb: runningVerb, values: [firstDistance, firstDuration])
        
        let secondDateString = "01-02-2017 10:00"
        let secondDuration = eventsModel.createValue(valueValue: 5.0, measure: kmMeasure)
        let secondDistance = eventsModel.createValue(valueValue: 32, measure: minutesMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: secondDateString)!, primaryNoun: horseNoun, verb: runningVerb, values: [secondDistance, secondDuration])
        
        let thirdDateString = "01-03-2017 10:00"
        let thirdDuration = eventsModel.createValue(valueValue: 5.0, measure: kmMeasure)
        let thirdDistance = eventsModel.createValue(valueValue: 30, measure: minutesMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: thirdDateString)!, primaryNoun: horseNoun, verb: runningVerb, values: [thirdDistance, thirdDuration])
        
        let fourthDateString = "15-03-2017 10:00"
        let fourthDuration = eventsModel.createValue(valueValue: 5.0, measure: kmMeasure)
        let fourthDistance = eventsModel.createValue(valueValue: 30, measure: minutesMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: fourthDateString)!, primaryNoun: horseNoun, verb: runningVerb, values: [fourthDistance, fourthDuration])
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 4)
        
        // TODO:  Make some assertions about total distance run each month...

        // TODO:  Improve how objects are printed...
        print(eventsModel.events!)
        
    }

    
    func testSownataEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let horseNoun = eventsModel.findNoun(id: "horse")
        
        let workVerb = eventsModel.createVerb(id: "work", name:"work")
        
        let hoursMeasure = eventsModel.createMeasure(id: "hours", name: "hours", verb: workVerb)
        
        let workTypeProperty = eventsModel.createProperty(id: "type", name: "type", verb: workVerb)
        
        let codingAttribute = eventsModel.createAttribute(attributeValue: "coding", property: workTypeProperty)
        let learningAttribute = eventsModel.createAttribute(attributeValue: "learning", property: workTypeProperty)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        // TODO:  Implement Support for Attributes
        
        // Development (GitHub Commits)

        var dateString = ""
        
        // ?
        dateString = "18-05-2017 00:00"
        var duration = eventsModel.createValue(valueValue: 2, measure: hoursMeasure)

        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [codingAttribute])
        
        // Everything below this comment was recorded "after the event"...
        
        // ae61654
        dateString = "11-05-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [codingAttribute])
  
        // 066b68c
        dateString = "07-05-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [codingAttribute])
        
        // 3c306fd, e18cef7, 86c3d20
        dateString = "05-05-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [codingAttribute])

        // 82f3281, 181dae8, ee8a71d
        dateString = "29-01-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [codingAttribute])

        // 4c20d64, 691ea5c
        dateString = "18-12-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [codingAttribute])

        // 3b99715, 9c0bfaf
        dateString = "19-04-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [codingAttribute])

        // Learning (iTunes University)
        
        // https://developer.apple.com/videos/play/wwdc2015/406/
        dateString = "15-03-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 1. Logistics, iOS 8 Overview
        dateString = "19-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])

        // iOS8 2. More Xcode and Swift, MVC
        dateString = "19-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 3. Applying MVC
        dateString = "20-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 4. More Swift and Foundation Frameworks
        dateString = "20-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 5. Objective-C Compatibility, Property List, Views
        dateString = "21-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 6. Protocols and Delegation, Gestures
        dateString = "22-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 7. Multiple MVCs
        dateString = "23-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 8. View Controller Lifecycle, Autolayout
        dateString = "25-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 9. Scroll View and Multithreading
        dateString = "26-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 10. Table View
        dateString = "28-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 11. Unwind Segues, Alerts, Timers, View Animation
        dateString = "26-01-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 12. Dynamic Animation
        dateString = "26-01-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 13. Application Lifecycle and Core Motion
        dateString = "05-02-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 14. Core Location and Map Kit
        dateString = "08-02-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 15. Modal Segues
        dateString = "14-02-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 16. Camera, Persistence and Embed Segues
        dateString = "23-02-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS8 17. Internationalisation and Settings
        dateString = "24-02-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        
        // iOS9 ?. Core Data
        dateString = "01-03-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS9 ?. Core Data Demo
        dateString = "01-03-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        
        // iOS10 ?. Core Data
        dateString = "01-04-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
        // iOS10 ?. Core Data Demo
        dateString = "01-04-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration], attributes: [learningAttribute])
        
 
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 29)
        
        // TODO:  Start recording this in the actual application...
        
        
    }

    
    
}
