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
    
    //# TODO: - Put all of my literals into a Struct
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EventsModel")
        let description = NSPersistentStoreDescription()
        description.type = NSSQLiteStoreType
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
        print("tearDown() running")
        //# TODO: - Ensure that the Store is cleaned up
        managedObjectContext = nil
    }
    
    override func setUp() {
        super.setUp()
        
        let applicationDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String
        print("setUp() running in '\(applicationDirectory)'")
        
        // Set the NSManagedObjectContext with the view Context
        managedObjectContext = self.persistentContainer.viewContext

        //# TODO: - This is called for each test (which probably isn't what I want)
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        _ = eventsModel.createNoun(id: "horse", name:"Horse")
        _ = eventsModel.createNoun(id: "pingi", name:"Pingi")
        _ = eventsModel.createNoun(id: "renee", name:"Renee")

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
        
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-01-2017 10:00")!, primaryNoun: horseNoun, verb: runningVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 5.0, measure: kmMeasure)
        _ = eventsModel.addValue(event: testEvent, valueValue: 30, measure: minutesMeasure)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-02-2017 10:00")!, primaryNoun: horseNoun, verb: runningVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 5.0, measure: kmMeasure)
        _ = eventsModel.addValue(event: testEvent, valueValue: 32, measure: minutesMeasure)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-03-2017 10:00")!, primaryNoun: horseNoun, verb: runningVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 5.0, measure: kmMeasure)
        _ = eventsModel.addValue(event: testEvent, valueValue: 30, measure: minutesMeasure)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "15-03-2017 10:00")!, primaryNoun: horseNoun, verb: runningVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 5.0, measure: kmMeasure)
        _ = eventsModel.addValue(event: testEvent, valueValue: 30, measure: minutesMeasure)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 4)
        
        let swimmingVerb = eventsModel.createVerb(id: "swim", name:"swam")

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "07-03-2017 10:00")!, primaryNoun: horseNoun, verb: swimmingVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1.0, measure: kmMeasure)
        _ = eventsModel.addValue(event: testEvent, valueValue: 30, measure: minutesMeasure)

        let runningEvents = eventsModel.getEventsForVerb(verb: runningVerb)

        XCTAssert(runningEvents?.count == 4)
        
        let runningEventsByMonth = eventsModel.getEventCountByMonthForVerb(verb: runningVerb)
        XCTAssert(runningEventsByMonth["Mar.2017"] == 2, "\(runningEventsByMonth["Mar.2017"]!) != 2")
        XCTAssert(runningEventsByMonth["Feb.2017"] == 1)
        
        // TODO:  Assert about the total distance run in the last 12 months
        
        let runningDistanceByMonth = eventsModel.getMeasureSumByMonthForVerb(verb: runningVerb, measure: kmMeasure)
        
        XCTAssert(runningDistanceByMonth["Jan.2017"] == 5, "\(runningDistanceByMonth["Jan.2017"]!) != 5")
        XCTAssert(runningDistanceByMonth["Mar.2017"] == 10, "\(runningDistanceByMonth["Mar.2017"]!) != 10")

        print("testRunningEvents() -> \(eventsModel.events!)")
    }

    func testWeighInEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count

        let horseNoun = eventsModel.findNoun(id: "horse")
        
        let weighVerb = eventsModel.createVerb(id: "weigh", name:"weighed")

        let kgMeasure = eventsModel.createMeasure(id: "kg", name: "kg", verb: weighVerb)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-01-2017 10:00")!, primaryNoun: horseNoun, verb: weighVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 95.0, measure: kgMeasure)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-02-2017 10:00")!, primaryNoun: horseNoun, verb: weighVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 93.0, measure: kgMeasure)
    
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-03-2017 10:00")!, primaryNoun: horseNoun, verb: weighVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 92.0, measure: kgMeasure)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "15-03-2017 10:00")!, primaryNoun: horseNoun, verb: weighVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 93.0, measure: kgMeasure)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 4)
        
        // TODO:  Assert about the weight change in the last 12 months
        
        print("testWeighInEvents() -> \(eventsModel.events!)")
    }
    
    func testIndulgedEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let horseNoun = eventsModel.findNoun(id: "horse")
        
        let indulgedVerb = eventsModel.createVerb(id: "indulged", name:"indulged")
        
        let indulgenceTypeProperty = eventsModel.createProperty(id: "type", name: "type", verb: indulgedVerb)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-01-2017 00:00")!, primaryNoun: horseNoun, verb: indulgedVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "cake", property: indulgenceTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-02-2017 10:00")!, primaryNoun: horseNoun, verb: indulgedVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "fizzy pop", property: indulgenceTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-02-2017 10:00")!, primaryNoun: horseNoun, verb: indulgedVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "fizzy pop", property: indulgenceTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-03-2017 10:00")!, primaryNoun: horseNoun, verb: indulgedVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "fizzy pop", property: indulgenceTypeProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-04-2017 10:00")!, primaryNoun: horseNoun, verb: indulgedVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "cake", property: indulgenceTypeProperty)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 5)
        
        // TODO:  Assert about the number of indulgences (by indulgence) last month
        
        print("testIndulgedEvents() -> \(eventsModel.events!)")
    }
    
    func testToiletCleaningEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let pingiNoun = eventsModel.findNoun(id: "pingi")
        let reneeNoun = eventsModel.findNoun(id: "renee")
        
        let cleanVerb = eventsModel.createVerb(id: "clean", name:"cleaned")
        let toiletNoun = eventsModel.createNoun(id: "toilet", name:"the Toilet")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        _ = eventsModel.createEvent(when: dateFormatter.date(from: "01-01-2017 10:00")!, primaryNoun: pingiNoun, verb: cleanVerb, secondaryNoun: toiletNoun)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 1)

        _ = eventsModel.createEvent(when: dateFormatter.date(from: "01-02-2017 10:00")!, primaryNoun: reneeNoun, verb: cleanVerb, secondaryNoun: toiletNoun)

        _ = eventsModel.createEvent(when: dateFormatter.date(from: "01-03-2017 10:00")!, primaryNoun: pingiNoun, verb: cleanVerb, secondaryNoun: toiletNoun)

        _ = eventsModel.createEvent(when: dateFormatter.date(from: "01-04-2017 10:00")!, primaryNoun: pingiNoun, verb: cleanVerb, secondaryNoun: toiletNoun)

        XCTAssert(eventsModel.events?.count == startingEventCount! + 4)
        
        // TODO:  Make an assertion about who cleans the toilet more often
        
        print("testToiletCleaningEvents() -> \(eventsModel.events!)")
    }
    
    func testSownataEvents() {
        // TODO:  Start recording this in the actual application...

        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let horseNoun = eventsModel.findNoun(id: "horse")
        
        let workVerb = eventsModel.createVerb(id: "work", name:"work")
        
        let hoursMeasure = eventsModel.createMeasure(id: "hours", name: "hours", verb: workVerb)
        
        let workTypeProperty = eventsModel.createProperty(id: "type", name: "type", verb: workVerb)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        // Development (GitHub Commits)

        // ?
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "22-06-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "coding", property: workTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "08-06-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 2, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "coding", property: workTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "05-06-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 6, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "coding", property: workTypeProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "31-05-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "coding", property: workTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "25-05-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 2, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "coding", property: workTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "18-05-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 2, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "coding", property: workTypeProperty)

        // Everything below this comment was recorded "after the event"...
        
        // ae61654
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "11-05-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "coding", property: workTypeProperty)
  
        // 066b68c
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "07-05-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "coding", property: workTypeProperty)
        
        // 3c306fd, e18cef7, 86c3d20
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "05-05-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "coding", property: workTypeProperty)

        // 82f3281, 181dae8, ee8a71d
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "29-01-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "coding", property: workTypeProperty)

        // 4c20d64, 691ea5c
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "18-12-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "coding", property: workTypeProperty)

        // 3b99715, 9c0bfaf
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "19-04-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "coding", property: workTypeProperty)

        // Learning (iTunes University)
        
        // https://developer.apple.com/videos/play/wwdc2015/406/
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "15-03-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 1. Logistics, iOS 8 Overview
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "19-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)

        // iOS8 2. More Xcode and Swift, MVC
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "19-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 3. Applying MVC
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "20-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 4. More Swift and Foundation Frameworks
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "20-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 5. Objective-C Compatibility, Property List, Views
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "21-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 6. Protocols and Delegation, Gestures
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "22-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 7. Multiple MVCs
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "23-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 8. View Controller Lifecycle, Autolayout
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "25-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 9. Scroll View and Multithreading
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "26-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 10. Table View
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "28-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 11. Unwind Segues, Alerts, Timers, View Animation
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "26-01-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 12. Dynamic Animation
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "26-01-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 13. Application Lifecycle and Core Motion
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "05-02-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 14. Core Location and Map Kit
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "08-02-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 15. Modal Segues
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "14-02-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)

        // iOS8 16. Camera, Persistence and Embed Segues
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "23-02-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS8 17. Internationalisation and Settings
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "24-02-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)

        
        // iOS9 ?. Core Data
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-03-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS9 ?. Core Data Demo
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-03-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS10 ?. Core Data
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-04-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)
        
        // iOS10 ?. Core Data Demo
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-04-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "learning", property: workTypeProperty)

        XCTAssert(eventsModel.events?.count == startingEventCount! + 34)
        
        // TODO:  Make an assertion about the hours worked in a given month

        print("testSownataEvents() -> \(eventsModel.events!)")

    }

    func testNetflixEvents() {
        
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let horseNoun = eventsModel.findNoun(id: "horse")
        
        let netflixVerb = eventsModel.createVerb(id: "netflix", name:"netflix")
        
        // TODO:  This should add the (already existing) Measure to the Verb
        let hoursMeasure = eventsModel.createMeasure(id: "hours", name: "hours", verb: netflixVerb)
        
        let neflixTypeProperty = eventsModel.createProperty(id: "type", name: "type", verb: netflixVerb)
        let nameProperty = eventsModel.createProperty(id: "name", name: "name", verb: netflixVerb)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        // ?
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-05-2017 00:00")!, primaryNoun: horseNoun, verb: netflixVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "doctor who", property: nameProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "tv", property: neflixTypeProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "02-05-2017 00:00")!, primaryNoun: horseNoun, verb: netflixVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 2, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "despicable me", property: nameProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "film", property: neflixTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "03-05-2017 00:00")!, primaryNoun: horseNoun, verb: netflixVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "doctor who", property: nameProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "tv", property: neflixTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "03-05-2017 00:00")!, primaryNoun: horseNoun, verb: netflixVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "doctor who", property: nameProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "tv", property: neflixTypeProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "04-05-2017 00:00")!, primaryNoun: horseNoun, verb: netflixVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 2, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "forest gump", property: nameProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "film", property: neflixTypeProperty)


        XCTAssert(eventsModel.events?.count == startingEventCount! + 5)
        
        // TODO:  Make an assertion about how much time was spent watching netflix
        // TODO:  Make an assertion about whether more time was spent watching TV or Movies
        
        print("testNetflixEvents() -> \(eventsModel.events!)")
        
    }
    

    func testFacebookEvents() {
        
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let horseNoun = eventsModel.findNoun(id: "horse")
        
        let facebookVerb = eventsModel.createVerb(id: "facebook", name:"facebook")
        
        let actionProperty = eventsModel.createProperty(id: "action", name: "action", verb: facebookVerb)
        let userProperty = eventsModel.createProperty(id: "user", name: "user", verb: facebookVerb)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        // ?
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "like", property: actionProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "pingi", property: userProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "02-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "like", property: actionProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "renee", property: userProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "02-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "like", property: actionProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "pingi", property: userProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "03-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "post", property: actionProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "04-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "post", property: actionProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "04-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "share", property: actionProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "renee", property: userProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "05-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "like", property: actionProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "pingi", property: userProperty)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 7)
        
        // TODO:  Make an assertion about how much I like vs. post vs. share
        // TODO:  Make an assertion about the number of actions last month
        
        print("testFacebookEvents() -> \(eventsModel.events!)")
        
    }

    
}
