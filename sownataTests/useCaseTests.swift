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
        // TODO:  Ensure that the Store is cleaned up
        managedObjectContext = nil
    }
    
    override func setUp() {
        super.setUp()
        
        let applicationDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String
        print("setUp() running in '\(applicationDirectory)'")
        
        // Set the NSManagedObjectContext with the view Context
        managedObjectContext = self.persistentContainer.viewContext
        
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
        
        let swimmingVerb = eventsModel.createVerb(id: "swim", name:"swam")

        let swimDateString = "07-03-2017 10:00"
        let swimDuration = eventsModel.createValue(valueValue: 1.0, measure: kmMeasure)
        let swimDistance = eventsModel.createValue(valueValue: 30, measure: minutesMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: swimDateString)!, primaryNoun: horseNoun, verb: swimmingVerb, values: [swimDistance, swimDuration])

        let runningEvents = eventsModel.getEventsForVerb(verb: runningVerb)

        XCTAssert(runningEvents?.count == 4)
        
        let runningEventsByMonth = eventsModel.getEventCountByMonthForVerb(verb: runningVerb)
        XCTAssert(runningEventsByMonth["Mar.2017"] == 2, "\(runningEventsByMonth["Mar.2017"]!) != 2")
        XCTAssert(runningEventsByMonth["Feb.2017"] == 1)
        
        // TODO:  Assert about the total distance run in the last 12 months
        
//        let something = eventsModel.getMeasureSumByMonthForVerb(verb: runningVerb, measure: kmMeasure)
        
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
        
        // TODO:  Assert about the weight change in the last 12 months
        
        print("testWeighInEvents() -> \(eventsModel.events!)")
    }
    
    func testIndulgedEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let horseNoun = eventsModel.findNoun(id: "horse")
        
        let indulgedVerb = eventsModel.createVerb(id: "indulged", name:"indulged")
        
        let indulgenceTypeProperty = eventsModel.createProperty(id: "type", name: "type", verb: indulgedVerb)
        
        let cakeAttribute = eventsModel.createAttribute(attributeValue: "cake", property: indulgenceTypeProperty)
        let fizzyPopAttribute = eventsModel.createAttribute(attributeValue: "fizzy pop", property: indulgenceTypeProperty)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        let firstDateString = "01-01-2017 00:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: firstDateString)!, primaryNoun: horseNoun, verb: indulgedVerb, values: [], attributes: [cakeAttribute])
        
        let secondDateString = "01-02-2017 10:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: secondDateString)!, primaryNoun: horseNoun, verb: indulgedVerb, values: [], attributes: [fizzyPopAttribute])
        
        let thirdDateString = "01-03-2017 10:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: thirdDateString)!, primaryNoun: horseNoun, verb: indulgedVerb, values: [], attributes: [fizzyPopAttribute])
        
        let fourthDateString = "01-04-2017 10:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: fourthDateString)!, primaryNoun: horseNoun, verb: indulgedVerb, values: [], attributes: [cakeAttribute])
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 4)
        
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
        
        _ = eventsModel.createEvent(primaryNoun: pingiNoun, verb: cleanVerb, secondaryNoun: toiletNoun)
        XCTAssert(eventsModel.events?.count == startingEventCount! + 1)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"

        let firstDateString = "01-01-2017 10:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: firstDateString)!, primaryNoun: pingiNoun, verb: cleanVerb, secondaryNoun: toiletNoun)

        let secondDateString = "01-02-2017 10:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: secondDateString)!, primaryNoun: pingiNoun, verb: cleanVerb, secondaryNoun: toiletNoun)

        let thirdDateString = "01-03-2017 10:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: thirdDateString)!, primaryNoun: reneeNoun, verb: cleanVerb, secondaryNoun: toiletNoun)
        
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
        
        let codingAttribute = eventsModel.createAttribute(attributeValue: "coding", property: workTypeProperty)
        let learningAttribute = eventsModel.createAttribute(attributeValue: "learning", property: workTypeProperty)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        // Development (GitHub Commits)

        var dateString = ""
        var duration: Value? = nil

        // ?
        dateString = "05-06-2017 00:00"
        duration = eventsModel.createValue(valueValue: 4, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [codingAttribute])

        // ?
        dateString = "31-05-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [codingAttribute])

        // ?
        dateString = "25-05-2017 00:00"
        duration = eventsModel.createValue(valueValue: 2, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [codingAttribute])

        // ?
        dateString = "18-05-2017 00:00"
        duration = eventsModel.createValue(valueValue: 2, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [codingAttribute])

        
        // Everything below this comment was recorded "after the event"...
        
        // ae61654
        dateString = "11-05-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [codingAttribute])
  
        // 066b68c
        dateString = "07-05-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [codingAttribute])
        
        // 3c306fd, e18cef7, 86c3d20
        dateString = "05-05-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [codingAttribute])

        // 82f3281, 181dae8, ee8a71d
        dateString = "29-01-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [codingAttribute])

        // 4c20d64, 691ea5c
        dateString = "18-12-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [codingAttribute])

        // 3b99715, 9c0bfaf
        dateString = "19-04-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [codingAttribute])

        // Learning (iTunes University)
        
        // https://developer.apple.com/videos/play/wwdc2015/406/
        dateString = "15-03-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 1. Logistics, iOS 8 Overview
        dateString = "19-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])

        // iOS8 2. More Xcode and Swift, MVC
        dateString = "19-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 3. Applying MVC
        dateString = "20-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 4. More Swift and Foundation Frameworks
        dateString = "20-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 5. Objective-C Compatibility, Property List, Views
        dateString = "21-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 6. Protocols and Delegation, Gestures
        dateString = "22-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 7. Multiple MVCs
        dateString = "23-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 8. View Controller Lifecycle, Autolayout
        dateString = "25-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 9. Scroll View and Multithreading
        dateString = "26-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 10. Table View
        dateString = "28-04-2016 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 11. Unwind Segues, Alerts, Timers, View Animation
        dateString = "26-01-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 12. Dynamic Animation
        dateString = "26-01-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 13. Application Lifecycle and Core Motion
        dateString = "05-02-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 14. Core Location and Map Kit
        dateString = "08-02-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 15. Modal Segues
        dateString = "14-02-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 16. Camera, Persistence and Embed Segues
        dateString = "23-02-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS8 17. Internationalisation and Settings
        dateString = "24-02-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        
        // iOS9 ?. Core Data
        dateString = "01-03-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS9 ?. Core Data Demo
        dateString = "01-03-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        
        // iOS10 ?. Core Data
        dateString = "01-04-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        // iOS10 ?. Core Data Demo
        dateString = "01-04-2017 00:00"
        duration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: workVerb, values: [duration!], attributes: [learningAttribute])
        
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 32)
        
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

        
        let tvAttribute = eventsModel.createAttribute(attributeValue: "coding", property: neflixTypeProperty)
        let movieAttribute = eventsModel.createAttribute(attributeValue: "learning", property: neflixTypeProperty)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        var dateString = ""
        
        dateString = "01-05-2017 00:00"
        let oneHourDuration = eventsModel.createValue(valueValue: 1, measure: hoursMeasure)
        let doctorWhoAttribute = eventsModel.createAttribute(attributeValue: "doctor who", property: nameProperty)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: netflixVerb, values: [oneHourDuration], attributes: [tvAttribute, doctorWhoAttribute])

        dateString = "02-05-2017 00:00"
        let twoHourDuration = eventsModel.createValue(valueValue: 2, measure: hoursMeasure)
        let despicableMeAttribute = eventsModel.createAttribute(attributeValue: "despicable me", property: nameProperty)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: netflixVerb, values: [twoHourDuration], attributes: [movieAttribute, despicableMeAttribute])

        dateString = "03-05-2017 00:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: netflixVerb, values: [oneHourDuration], attributes: [tvAttribute, doctorWhoAttribute])
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: netflixVerb, values: [oneHourDuration], attributes: [tvAttribute, doctorWhoAttribute])

        dateString = "04-05-2017 00:00"
        let forrestGumpAttribute = eventsModel.createAttribute(attributeValue: "forest gump", property: nameProperty)
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: netflixVerb, values: [twoHourDuration], attributes: [movieAttribute, forrestGumpAttribute])


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
        
        let reneeAttribute = eventsModel.createAttribute(attributeValue: "renee", property: userProperty)
        let pingiAttribute = eventsModel.createAttribute(attributeValue: "pingi", property: userProperty)

        let likeAttribute = eventsModel.createAttribute(attributeValue: "like", property: actionProperty)
        let shareAttribute = eventsModel.createAttribute(attributeValue: "share", property: actionProperty)
        let postAttribute = eventsModel.createAttribute(attributeValue: "post", property: actionProperty)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        var dateString = ""
        
        dateString = "01-05-2017 00:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: facebookVerb, values: [], attributes: [likeAttribute, pingiAttribute])
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: facebookVerb, values: [], attributes: [likeAttribute, pingiAttribute])
        
        dateString = "02-05-2017 00:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: facebookVerb, values: [], attributes: [postAttribute])
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: facebookVerb, values: [], attributes: [likeAttribute, pingiAttribute])
        
        dateString = "03-05-2017 00:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: facebookVerb, values: [], attributes: [postAttribute])
        
        dateString = "04-05-2017 00:00"
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: facebookVerb, values: [], attributes: [shareAttribute, reneeAttribute])
        _ = eventsModel.createEvent(when: dateFormatter.date(from: dateString)!, primaryNoun: horseNoun, verb: facebookVerb, values: [], attributes: [postAttribute])
        
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 7)
        
        // TODO:  Make an assertion about how much I like vs. post vs. share
        // TODO:  Make an assertion about the number of actions last month
        
        print("testFacebookEvents() -> \(eventsModel.events!)")
        
    }

    
}
