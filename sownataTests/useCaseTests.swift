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
    
    
    func testEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let horseNoun = eventsModel.findNoun(id: "horse")
        
        let cleanVerb = eventsModel.createVerb(id: "clean", name:"cleaned")
        let toiletNoun = eventsModel.createNoun(id: "toilet", name:"the Toilet")
        
        _ = eventsModel.createEvent(primaryNoun: horseNoun, verb: cleanVerb, secondaryNoun: toiletNoun)
        XCTAssert(eventsModel.events?.count == 1)
        _ = eventsModel.createEvent(primaryNoun: horseNoun, verb: cleanVerb, secondaryNoun: toiletNoun)
        _ = eventsModel.createEvent(primaryNoun: horseNoun, verb: cleanVerb, secondaryNoun: toiletNoun)
        _ = eventsModel.createEvent(primaryNoun: horseNoun, verb: cleanVerb, secondaryNoun: toiletNoun)
        XCTAssert(eventsModel.events?.count == 4)

        print(eventsModel.events!)
    }
    
}
