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

        XCTAssert(eventsModel.verbs?.count == 7, "Expected \(7) Verbs but found \(String(describing: eventsModel.verbs?.count))")

        _ = eventsModel.createVerb(id: "swim", name: "swim")
        XCTAssert(eventsModel.verbs?.count == 8, "Expected \(8) Verbs but found \(String(describing: eventsModel.verbs?.count))")
        
        _ = eventsModel.createVerb(id: "swim", name: "swim")
        XCTAssert(eventsModel.verbs?.count == 8, "Expected \(8) Verbs but found \(String(describing: eventsModel.verbs?.count))")
    }

    func testNouns() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        XCTAssert(eventsModel.nouns?.count == 3, "Expected \(3) Nouns but found \(String(describing: eventsModel.nouns?.count))")
        
        _ = eventsModel.createNoun(id: "horse", name: "horse")
        XCTAssert(eventsModel.nouns?.count == 4, "Expected \(4) Nouns but found \(String(describing: eventsModel.nouns?.count))")
        
        _ = eventsModel.createNoun(id: "horse", name: "horse")
        XCTAssert(eventsModel.nouns?.count == 4, "Expected \(4) Nouns but found \(String(describing: eventsModel.nouns?.count))")
        
        XCTAssert(eventsModel.pronouns?.count == 1, "Expected \(1) Pronouns but found \(String(describing: eventsModel.pronouns?.count))")
    }
    
    func testEvents() {
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let meNoun = eventsModel.findNoun(id: "me")
        let indulgeVerb = eventsModel.findVerb(id: "indulge")
        let cakeNoun = eventsModel.findNoun(id: "cake")
        
        _ = eventsModel.createEvent(when: Date(), primaryNoun: meNoun!, verb: indulgeVerb!, secondaryNoun: cakeNoun!)
        XCTAssert(eventsModel.events?.count == 1)
        
        let watchVerb = eventsModel.findVerb(id: "watch")
        let sourceProperty = eventsModel.findProperty(id: "source")
        let typeProperty = eventsModel.findProperty(id: "type")
        let hoursMeasure = eventsModel.findMeasure(id: "hours")

        let watchEvent = eventsModel.createEvent(when: Date(), primaryNoun: meNoun!, verb: watchVerb!)
        XCTAssert(eventsModel.events?.count == 2)
        
        _ = eventsModel.addAttribute(event: watchEvent, attributeValue: "Netflix", property: sourceProperty!)
        _ = eventsModel.addAttribute(event: watchEvent, attributeValue: "Film", property: typeProperty!)
        _ = eventsModel.addValue(event: watchEvent, valueValue: 2.0, measure: hoursMeasure!)

        // TODO:  Add XCTAssert(s) for Attributes and Value
    }
    
}
