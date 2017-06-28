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
    
    private struct Constants {
        static let DateFormat = "dd-MM-yyyy HH:mm"
    }
    
    private struct PrimaryNoun {
        static let Horse = "horse"
        static let Pingi = "pingi"
        static let Renee = "pingi"
        
    }

    private struct Verb {
        static let Run = "run"
        static let Swim = "swim"
        static let Weigh = "weigh"
        static let Indulge = "indulge"
        static let Clean = "clean"
        static let Work = "work"
        static let Netflix = "netflix"
        static let Facebook = "facebook"
    }

    private struct Measure {
        static let KM = "km"
        static let Minutes = "minutes"
        static let KG = "kg"
        static let Hours = "hours"
        
    }

    private struct Property {
        static let PropertyType = "type"
        static let Name = "name"
        static let Action = "action"
        static let User = "user"
        
    }
    
    private struct Attribute {
        static let Coding = "coding"
        static let Learning = "learning"
        static let Cake = "cake"
        static let FizzyPop = "fizzy pop"
        static let ForestGump = "forest gump"
        static let DoctorWho = "doctor who"
        static let TV = "tv"
        static let Film = "film"
        static let DespicableMe = "despicable me"
        static let Like = "like"
        static let Share = "share"
        static let Post = "post"
        
    }

    private struct SecondaryNoun {
        static let Toilet = "toilet"
        
    }
    
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
        //# TODO: - Fix up the lifecycle of my Persistent Store
        managedObjectContext = nil
    }
    
    override func setUp() {
        super.setUp()
        
        let applicationDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String
        print("setUp() running in '\(applicationDirectory)'")
        
        // Set the NSManagedObjectContext with the view Context
        managedObjectContext = self.persistentContainer.viewContext

        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        _ = eventsModel.createNoun(id: PrimaryNoun.Horse, name: PrimaryNoun.Horse)
        _ = eventsModel.createNoun(id: PrimaryNoun.Pingi, name:PrimaryNoun.Pingi)
        _ = eventsModel.createNoun(id: PrimaryNoun.Renee, name:PrimaryNoun.Renee)

    }
    
    func testRunningEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let horseNoun = eventsModel.findNoun(id: PrimaryNoun.Horse)
        
        let runningVerb = eventsModel.createVerb(id: Verb.Run, name: Verb.Run)
        
        let kmMeasure = eventsModel.createMeasure(id: Measure.KM, name: Measure.KM, verb: runningVerb)
        let minutesMeasure = eventsModel.createMeasure(id: Measure.Minutes, name: Measure.Minutes, verb: runningVerb)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat
        
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
        
        let swimmingVerb = eventsModel.createVerb(id: Verb.Swim, name: Verb.Swim)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "07-03-2017 10:00")!, primaryNoun: horseNoun, verb: swimmingVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1.0, measure: kmMeasure)
        _ = eventsModel.addValue(event: testEvent, valueValue: 30, measure: minutesMeasure)

        let runningEvents = eventsModel.getEventsForVerb(verb: runningVerb)

        XCTAssert(runningEvents?.count == 4)
        
        let runningEventsByMonth = eventsModel.getEventCountByMonthForVerb(verb: runningVerb)
        XCTAssert(runningEventsByMonth["Mar.2017"] == 2, "\(runningEventsByMonth["Mar.2017"]!) != 2")
        XCTAssert(runningEventsByMonth["Feb.2017"] == 1)
        
        let runningDistanceByMonth = eventsModel.getMeasureAggregateByMonthForVerb(verb: runningVerb, measure: kmMeasure, aggregateFunction: EventsModel.AggregateFunction.Sum)
        
        XCTAssert(runningDistanceByMonth["Jan.2017"] == 5, "\(runningDistanceByMonth["Jan.2017"]!) != 5")
        XCTAssert(runningDistanceByMonth["Mar.2017"] == 10, "\(runningDistanceByMonth["Mar.2017"]!) != 10")

        print("testRunningEvents() -> \(eventsModel.events!)")
    }

    func testWeighInEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count

        let horseNoun = eventsModel.findNoun(id: PrimaryNoun.Horse)
        
        let weighVerb = eventsModel.createVerb(id: Verb.Weigh, name: Verb.Weigh)

        let kgMeasure = eventsModel.createMeasure(id: Measure.KG, name: Measure.KG, verb: weighVerb)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat
        
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-01-2017 10:00")!, primaryNoun: horseNoun, verb: weighVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 95.0, measure: kgMeasure)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-02-2017 10:00")!, primaryNoun: horseNoun, verb: weighVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 93.0, measure: kgMeasure)
    
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-03-2017 10:00")!, primaryNoun: horseNoun, verb: weighVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 92.0, measure: kgMeasure)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "15-03-2017 10:00")!, primaryNoun: horseNoun, verb: weighVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 93.0, measure: kgMeasure)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 4)
        
        let averageWeightByMonth = eventsModel.getMeasureAggregateByMonthForVerb(verb: weighVerb, measure: kgMeasure, aggregateFunction: EventsModel.AggregateFunction.Average)
        XCTAssert(averageWeightByMonth["Jan.2017"]! > averageWeightByMonth["Mar.2017"]!, "\(averageWeightByMonth["Jan.2017"]!) !> \(averageWeightByMonth["Mar.2017"]!)")
        
        print("testWeighInEvents() -> \(eventsModel.events!)")
    }
    
    func testIndulgedEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let horseNoun = eventsModel.findNoun(id: PrimaryNoun.Horse)
        
        let indulgedVerb = eventsModel.createVerb(id: Verb.Indulge, name: Verb.Indulge)
        
        let indulgenceTypeProperty = eventsModel.createProperty(id: Property.PropertyType, name: Property.PropertyType, verb: indulgedVerb)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat
        
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-01-2017 00:00")!, primaryNoun: horseNoun, verb: indulgedVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Cake, property: indulgenceTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-02-2017 10:00")!, primaryNoun: horseNoun, verb: indulgedVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.FizzyPop, property: indulgenceTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-02-2017 10:00")!, primaryNoun: horseNoun, verb: indulgedVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.FizzyPop, property: indulgenceTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-03-2017 10:00")!, primaryNoun: horseNoun, verb: indulgedVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.FizzyPop, property: indulgenceTypeProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-04-2017 10:00")!, primaryNoun: horseNoun, verb: indulgedVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Cake, property: indulgenceTypeProperty)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 5)
        
        //# TODO: - Implement Date Filter
        let indulgencesInJanuary = eventsModel.getPropertyCountsForVerbBetweenDates(verb: indulgedVerb, property: indulgenceTypeProperty)
        
        XCTAssert(indulgencesInJanuary[Attribute.FizzyPop] == 3, "\(indulgencesInJanuary[Attribute.FizzyPop]!) != 3")
        XCTAssert(indulgencesInJanuary[Attribute.Cake] == 2, "\(indulgencesInJanuary[Attribute.Cake]!) != 2")

        print("testIndulgedEvents() -> \(eventsModel.events!)")
    }
    
    func testToiletCleaningEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let pingiNoun = eventsModel.findNoun(id: PrimaryNoun.Pingi)
        let reneeNoun = eventsModel.findNoun(id: PrimaryNoun.Renee)
        
        let cleanVerb = eventsModel.createVerb(id: Verb.Clean, name: Verb.Clean)
        let toiletNoun = eventsModel.createNoun(id: SecondaryNoun.Toilet, name: SecondaryNoun.Toilet)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat
        
        _ = eventsModel.createEvent(when: dateFormatter.date(from: "01-01-2017 10:00")!, primaryNoun: pingiNoun, verb: cleanVerb, secondaryNoun: toiletNoun)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 1)

        _ = eventsModel.createEvent(when: dateFormatter.date(from: "01-02-2017 10:00")!, primaryNoun: reneeNoun, verb: cleanVerb, secondaryNoun: toiletNoun)

        _ = eventsModel.createEvent(when: dateFormatter.date(from: "01-03-2017 10:00")!, primaryNoun: pingiNoun, verb: cleanVerb, secondaryNoun: toiletNoun)

        _ = eventsModel.createEvent(when: dateFormatter.date(from: "01-04-2017 10:00")!, primaryNoun: pingiNoun, verb: cleanVerb, secondaryNoun: toiletNoun)

        XCTAssert(eventsModel.events?.count == startingEventCount! + 4)
        
        // TODO:  Make an assertion about who cleans the toilet more often
        // _ = eventsModel.getNounCountsForVerbAndSecondaryNounBetweenDates(verb: cleanVerb)
        // Can I define this interface as one method?
        // or at least less methods e.g.
        // getNounCounts
        // getPropertyCounts
        // getMonthCounts
        // and
        // getNounMeasureAggregate
        // getPropertyMeasureAggregate
        // getMonthMeasureAggregate
        // maybe if measure is null then use count?

        
        print("testToiletCleaningEvents() -> \(eventsModel.events!)")
    }
    
    func testSownataEvents() {
        // TODO:  Start recording this in the actual application...

        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let horseNoun = eventsModel.findNoun(id: PrimaryNoun.Horse)
        
        let workVerb = eventsModel.createVerb(id: Verb.Work, name: Verb.Work)
        
        let hoursMeasure = eventsModel.createMeasure(id: Measure.Hours, name: Measure.Hours, verb: workVerb)
        
        let workTypeProperty = eventsModel.createProperty(id: Property.PropertyType, name: Property.PropertyType, verb: workVerb)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat
        
        // Development (GitHub Commits)

        // ?
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "26-06-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 2, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Coding, property: workTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "22-06-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Coding, property: workTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "08-06-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 2, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Coding, property: workTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "05-06-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 6, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Coding, property: workTypeProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "31-05-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Coding, property: workTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "25-05-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 2, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Coding, property: workTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "18-05-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 2, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Coding, property: workTypeProperty)

        // Everything below this comment was recorded "after the event"...
        
        // ae61654
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "11-05-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Coding, property: workTypeProperty)
  
        // 066b68c
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "07-05-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Coding, property: workTypeProperty)
        
        // 3c306fd, e18cef7, 86c3d20
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "05-05-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Coding, property: workTypeProperty)

        // 82f3281, 181dae8, ee8a71d
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "29-01-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Coding, property: workTypeProperty)

        // 4c20d64, 691ea5c
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "18-12-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Coding, property: workTypeProperty)

        // 3b99715, 9c0bfaf
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "19-04-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Coding, property: workTypeProperty)

        // Learning (iTunes University)
        
        // https://developer.apple.com/videos/play/wwdc2015/406/
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "15-03-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 1. Logistics, iOS 8 Overview
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "19-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)

        // iOS8 2. More Xcode and Swift, MVC
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "19-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 3. Applying MVC
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "20-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 4. More Swift and Foundation Frameworks
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "20-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 5. Objective-C Compatibility, Property List, Views
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "21-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 6. Protocols and Delegation, Gestures
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "22-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 7. Multiple MVCs
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "23-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 8. View Controller Lifecycle, Autolayout
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "25-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 9. Scroll View and Multithreading
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "26-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 10. Table View
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "28-04-2016 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 11. Unwind Segues, Alerts, Timers, View Animation
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "26-01-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 12. Dynamic Animation
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "26-01-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 13. Application Lifecycle and Core Motion
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "05-02-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 14. Core Location and Map Kit
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "08-02-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 15. Modal Segues
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "14-02-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)

        // iOS8 16. Camera, Persistence and Embed Segues
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "23-02-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS8 17. Internationalisation and Settings
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "24-02-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)

        
        // iOS9 ?. Core Data
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-03-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS9 ?. Core Data Demo
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-03-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS10 ?. Core Data
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-04-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)
        
        // iOS10 ?. Core Data Demo
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-04-2017 00:00")!, primaryNoun: horseNoun, verb: workVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Learning, property: workTypeProperty)

        XCTAssert(eventsModel.events?.count == startingEventCount! + 35)
        
        // TODO:  Make an assertion about the hours worked in a given month

        print("testSownataEvents() -> \(eventsModel.events!)")

    }

    func testNetflixEvents() {
        
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let horseNoun = eventsModel.findNoun(id: PrimaryNoun.Horse)
        
        let netflixVerb = eventsModel.createVerb(id: Verb.Netflix, name: Verb.Netflix)
        
        // TODO:  This should add the (already existing) Measure to the Verb
        let hoursMeasure = eventsModel.createMeasure(id: Measure.Hours, name: Measure.Hours, verb: netflixVerb)
        
        let neflixTypeProperty = eventsModel.createProperty(id: Property.PropertyType, name: Property.PropertyType, verb: netflixVerb)
        let nameProperty = eventsModel.createProperty(id: Property.Name, name: Property.Name, verb: netflixVerb)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat
        
        // ?
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-05-2017 00:00")!, primaryNoun: horseNoun, verb: netflixVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.DoctorWho, property: nameProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.TV, property: neflixTypeProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "02-05-2017 00:00")!, primaryNoun: horseNoun, verb: netflixVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 2, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.DespicableMe, property: nameProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Film, property: neflixTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "03-05-2017 00:00")!, primaryNoun: horseNoun, verb: netflixVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.DoctorWho, property: nameProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.TV, property: neflixTypeProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "03-05-2017 00:00")!, primaryNoun: horseNoun, verb: netflixVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.DoctorWho, property: nameProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.TV, property: neflixTypeProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "04-05-2017 00:00")!, primaryNoun: horseNoun, verb: netflixVerb)
        _ = eventsModel.addValue(event: testEvent, valueValue: 2, measure: hoursMeasure)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.ForestGump, property: nameProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Film, property: neflixTypeProperty)


        XCTAssert(eventsModel.events?.count == startingEventCount! + 5)
        
        // TODO:  Make an assertion about how much time was spent watching netflix
        // TODO:  Make an assertion about whether more time was spent watching TV or Movies
        
        print("testNetflixEvents() -> \(eventsModel.events!)")
        
    }
    

    func testFacebookEvents() {
        
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let horseNoun = eventsModel.findNoun(id: PrimaryNoun.Horse)
        
        let facebookVerb = eventsModel.createVerb(id: Verb.Facebook, name: Verb.Facebook)
        
        let actionProperty = eventsModel.createProperty(id: Property.Action, name: Property.Action, verb: facebookVerb)
        let userProperty = eventsModel.createProperty(id: Property.User, name: Property.User, verb: facebookVerb)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat
        
        // ?
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Like, property: actionProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: PrimaryNoun.Pingi, property: userProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "02-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Like, property: actionProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: PrimaryNoun.Renee, property: userProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "02-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Like, property: actionProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: PrimaryNoun.Pingi, property: userProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "03-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Post, property: actionProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "04-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Post, property: actionProperty)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "04-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Share, property: actionProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: PrimaryNoun.Renee, property: userProperty)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "05-05-2017 00:00")!, primaryNoun: horseNoun, verb: facebookVerb)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: Attribute.Like, property: actionProperty)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: PrimaryNoun.Pingi, property: userProperty)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 7)
        
        // TODO:  Make an assertion about how much I like vs. post vs. share
        // TODO:  Make an assertion about the number of actions last month
        
        print("testFacebookEvents() -> \(eventsModel.events!)")
        
    }

    
}
