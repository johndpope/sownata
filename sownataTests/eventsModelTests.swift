//
//  eventsModelTests.swift
//  eventsModelTests
//
//  Created by Gary Joy on 19/04/2016.
//
//

import XCTest

import CoreData

@testable import sownata

@available(iOS 10.0, *)
class eventsModelTests: XCTestCase {
    
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
    }
    

    func testVerbs() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)

        XCTAssert(eventsModel.verbs?.count == 0)

        _ = eventsModel.createVerb(id: "basketball", name:"played basketball")
        XCTAssert(eventsModel.verbs?.count == 1)
        
        _ = eventsModel.createVerb(id: "badminton", name:"played badminton")
        XCTAssert(eventsModel.verbs?.count == 2)
        
        _ = eventsModel.createVerb(id: "eat", name:"ate")
        XCTAssert(eventsModel.verbs?.count == 3)
        
        //# TODO: - What should happen if you try and create a Verb that already exists?
    }

    func testNouns() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        XCTAssert(eventsModel.nouns?.count == 0)
        
        _ = eventsModel.createNoun(id: "gary", name:"Gary")
        XCTAssert(eventsModel.nouns?.count == 1)
        
        _ = eventsModel.createNoun(id: "horse", name:"Horse")
        XCTAssert(eventsModel.nouns?.count == 2)
        
        _ = eventsModel.createNoun(id: "pingi", name:"Pingi")
        XCTAssert(eventsModel.nouns?.count == 3)
        
        //# TODO: - What should happen if you try and create a Noun that already exists?
    }
    
    func testEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let swimVerb = eventsModel.createVerb(id: "swim", name:"swam")
        let reneeNoun = eventsModel.createNoun(id: "renee", name:"Renee")
        
        _ = eventsModel.createEvent(primaryNoun: reneeNoun, verb: swimVerb)
        XCTAssert(eventsModel.events?.count == 1)
    }
    
}
