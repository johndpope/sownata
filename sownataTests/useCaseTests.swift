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
        
        print(eventsModel.events!)

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
    }
    
}
