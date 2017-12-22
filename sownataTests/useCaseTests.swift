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
        managedObjectContext = nil
    }
    
    override func setUp() {
        super.setUp()
        // Set the NSManagedObjectContext with the view Context
        managedObjectContext = self.persistentContainer.viewContext
    }
    
    func testRunEvents() {
        /*
         Use Case = On Monday I ran 5km in 30m
         Data = Monday | Gary | Run | [Distance=5(Value)-km(Measure)] [Duration=30(Value)-Minutes(Measure)]
         Chart = Monthly Number of Runs in the Last 12 Months?
         Chart = Monthly Total of Distance Ran in the Last 12 Months?
         */
        
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count

        let meNoun = eventsModel.findNoun(id: "me")
        let runVerb = eventsModel.findVerb(id: "run")
        
        let runEvent = eventsModel.createEvent(when: Date(), primaryNoun: meNoun!, verb: runVerb!, secondaryNoun: nil)
        XCTAssert(eventsModel.events?.count == 1)
        
        let kmMeasure = eventsModel.findMeasure(id: "km")
        let minutesMeasure = eventsModel.findMeasure(id: "minutes")

        _ = eventsModel.addValue(event: runEvent, valueValue: 5.0, measure: kmMeasure!)
        _ = eventsModel.addValue(event: runEvent, valueValue: 30, measure: minutesMeasure!)

        XCTAssert(runEvent.values!.count == 2, "Expected \(1) Values but found \(String(describing: runEvent.values!.count))")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat
        
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-01-2017 10:00")!, primaryNoun: meNoun!, verb: runVerb!, secondaryNoun: nil)
        _ = eventsModel.addValue(event: testEvent, valueValue: 5.0, measure: kmMeasure!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 30, measure: minutesMeasure!)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-02-2017 10:00")!, primaryNoun: meNoun!, verb: runVerb!, secondaryNoun: nil)
        _ = eventsModel.addValue(event: testEvent, valueValue: 5.0, measure: kmMeasure!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 32, measure: minutesMeasure!)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-03-2017 10:00")!, primaryNoun: meNoun!, verb: runVerb!, secondaryNoun: nil)
        _ = eventsModel.addValue(event: testEvent, valueValue: 5.0, measure: kmMeasure!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 30, measure: minutesMeasure!)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "10-03-2017 10:00")!, primaryNoun: meNoun!, verb: runVerb!, secondaryNoun: nil)
        _ = eventsModel.addValue(event: testEvent, valueValue: 5.0, measure: kmMeasure!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 30, measure: minutesMeasure!)

        XCTAssert(eventsModel.events?.count == startingEventCount! + 5)
        
        let runningEventsByMonthViewpoint = EventsModel.Viewpoint(viewpointVerb: runVerb!)
        let runningEventsByMonth = eventsModel.getChartData(viewpoint: runningEventsByMonthViewpoint)
        
        XCTAssert(runningEventsByMonth["Mar.2017"] == 2, "\(runningEventsByMonth["Mar.2017"]!) != 2")
        XCTAssert(runningEventsByMonth["Feb.2017"] == 1)
        
        let runningDistanceByMonthViewpoint = EventsModel.Viewpoint(viewpointVerb: runVerb!, viewpointDimension: kmMeasure!, viewpointFunction: EventsModel.AggregateFunction.Sum)
        let runningDistanceByMonth = eventsModel.getChartData(viewpoint: runningDistanceByMonthViewpoint)
        
        XCTAssert(runningDistanceByMonth["Jan.2017"] == 5, "\(runningDistanceByMonth["Jan.2017"]!) != 5")
        XCTAssert(runningDistanceByMonth["Mar.2017"] == 10, "\(runningDistanceByMonth["Mar.2017"]!) != 10")
        
        let totalDistanceRun = Array(runningDistanceByMonth.values).reduce(0, +)
        XCTAssert(totalDistanceRun == 25, "\(totalDistanceRun) != 25")

    }

    func testWeighEvents() {
        /*
         Use Case = On Wednesday Morning I weighed 90kg
         Data = Wednesday | Gary | Measure | [Weight=90(Value)-kg(Measure)]
         Chart = Average Weight has Decreased
         */

        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count

        let meNoun = eventsModel.findNoun(id: "me")

        let weighVerb = eventsModel.findVerb(id: "weigh")
        
        let kgMeasure = eventsModel.findMeasure(id: "kg")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat
        
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-01-2017 10:00")!, primaryNoun: meNoun!, verb: weighVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 95.0, measure: kgMeasure!)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-02-2017 10:00")!, primaryNoun: meNoun!, verb: weighVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 93.0, measure: kgMeasure!)
    
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-03-2017 10:00")!, primaryNoun: meNoun!, verb: weighVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 92.0, measure: kgMeasure!)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "15-03-2017 10:00")!, primaryNoun: meNoun!, verb: weighVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 93.0, measure: kgMeasure!)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 4)
        
        let averageWeightByMonthViewpoint = EventsModel.Viewpoint(viewpointVerb: weighVerb!, viewpointDimension: kgMeasure!, viewpointFunction: EventsModel.AggregateFunction.Average)
        let averageWeightByMonth = eventsModel.getChartData(viewpoint: averageWeightByMonthViewpoint)
        XCTAssert(averageWeightByMonth["Jan.2017"]! > averageWeightByMonth["Mar.2017"]!, "\(averageWeightByMonth["Jan.2017"]!) !> \(averageWeightByMonth["Mar.2017"]!)")
    }
    
    func testIndulgeEvents() {
        /*
         User Case = On Thursday I indulged in Cake / On Friday I indulged in Coca Cola
         Data = Thursday | Gary | Indulged | Cake
         Chart = Total Number of Indulgences (by Indulgence)
         Chart = Number of Indulgences in the Last Month
         */
        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let meNoun = eventsModel.findNoun(id: "me")
        
        let indulgedVerb = eventsModel.findVerb(id: "indulge")
        
        let indulgenceTypeProperty = eventsModel.findProperty(id: "type")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat
     
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-01-2017 00:00")!, primaryNoun: meNoun!, verb: indulgedVerb!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "cake", property: indulgenceTypeProperty!)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "02-01-2017 10:00")!, primaryNoun: meNoun!, verb: indulgedVerb!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "fizzy pop", property: indulgenceTypeProperty!)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "03-01-2017 10:00")!, primaryNoun: meNoun!, verb: indulgedVerb!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "fizzy pop", property: indulgenceTypeProperty!)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "04-01-2017 10:00")!, primaryNoun: meNoun!, verb: indulgedVerb!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "fizzy pop", property: indulgenceTypeProperty!)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-02-2017 10:00")!, primaryNoun: meNoun!, verb: indulgedVerb!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "cake", property: indulgenceTypeProperty!)

        XCTAssert(eventsModel.events?.count == startingEventCount! + 5)
        
        let indulgencesByTypeViewpoint = EventsModel.Viewpoint(viewpointVerb: indulgedVerb!, viewpointDimension: indulgenceTypeProperty!)
        let indulgencesByType = eventsModel.getChartData(viewpoint: indulgencesByTypeViewpoint)

        XCTAssert(indulgencesByType["fizzy pop"] == 3, "\(indulgencesByType["fizzy pop"]!) != 3")
        XCTAssert(indulgencesByType["cake"] == 2, "\(indulgencesByType["cake"]!) != 1")
    }
    
    func testWorkEvents() {
        /*
         Use Case = On Sunday I worked for eight hours
         Data = Sunday | Gary | Worked | Hours=8
         Chart = What are my Working Hours Every Month
         */

        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let meNoun = eventsModel.findNoun(id: "me")
        
        let workVerb = eventsModel.findVerb(id: "work")
        
        let hoursMeasure = eventsModel.findMeasure(id: "hours")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat
        
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-01-2017 00:00")!, primaryNoun: meNoun!, verb: workVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 8.0, measure: hoursMeasure!)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "02-01-2017 10:00")!, primaryNoun: meNoun!, verb: workVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 8.0, measure: hoursMeasure!)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "03-01-2017 10:00")!, primaryNoun: meNoun!, verb: workVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 8.0, measure: hoursMeasure!)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "04-01-2017 10:00")!, primaryNoun: meNoun!, verb: workVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 8.0, measure: hoursMeasure!)

        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-02-2017 10:00")!, primaryNoun: meNoun!, verb: workVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 8.0, measure: hoursMeasure!)

        XCTAssert(eventsModel.events?.count == startingEventCount! + 5)
        
        let hoursWorkedByMonthViewpoint = EventsModel.Viewpoint(viewpointVerb: workVerb!, viewpointDimension: hoursMeasure!, viewpointFunction: EventsModel.AggregateFunction.Sum)
        let hoursWorkedByMonth = eventsModel.getChartData(viewpoint: hoursWorkedByMonthViewpoint)
        
        XCTAssert(hoursWorkedByMonth["Jan.2017"] == 32, "\(hoursWorkedByMonth["Jan.2017"]!) != 32")
        XCTAssert(hoursWorkedByMonth["Feb.2017"] == 8, "\(hoursWorkedByMonth["Feb.2017"]!) != 8")
    }

    func testWatchEvents() {
        /*
         Use Case = On Wednesday I watched 2h film on Netflix
         Data = Wednesday | Gary | Netflix | Film&nbsp;| DurationHours=2
         Chart = How Much Time do I spend Watching Netflix
         Chart = Do I Watch more Films or Shows
         */

        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let meNoun = eventsModel.findNoun(id: "me")
        
        let watchVerb = eventsModel.findVerb(id: "watch")
        
        let hoursMeasure = eventsModel.findMeasure(id: "hours")
        let typeProperty = eventsModel.findProperty(id: "type")
        let nameProperty = eventsModel.findProperty(id: "name")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat
        
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-05-2017 00:00")!, primaryNoun: meNoun!, verb: watchVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "Doctor Who", property: nameProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "tv", property: typeProperty!)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "02-05-2017 00:00")!, primaryNoun: meNoun!, verb: watchVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 2, measure: hoursMeasure!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "Despicable Me", property: nameProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "film", property: typeProperty!)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "03-05-2017 00:00")!, primaryNoun: meNoun!, verb: watchVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "Doctor Who", property: nameProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "tv", property: typeProperty!)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "03-05-2017 00:00")!, primaryNoun: meNoun!, verb: watchVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 1, measure: hoursMeasure!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "Doctor Who", property: nameProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "tv", property: typeProperty!)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "04-05-2017 00:00")!, primaryNoun: meNoun!, verb: watchVerb!)
        _ = eventsModel.addValue(event: testEvent, valueValue: 2, measure: hoursMeasure!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "Forest Gump", property: nameProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "film", property: typeProperty!)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 5)
        
        let hoursWatchedByMonthViewpoint = EventsModel.Viewpoint(viewpointVerb: watchVerb!, viewpointDimension: hoursMeasure!, viewpointFunction: EventsModel.AggregateFunction.Sum)
        let hoursWatchedByMonth = eventsModel.getChartData(viewpoint: hoursWatchedByMonthViewpoint)
        
        XCTAssert(hoursWatchedByMonth["May.2017"] == 7, "\(hoursWatchedByMonth["May.2017"]!) != 7")

        
        let itemsWatchedByTypeViewpoint = EventsModel.Viewpoint(viewpointVerb: watchVerb!, viewpointDimension: typeProperty!)
        let itemsWatchedByType = eventsModel.getChartData(viewpoint: itemsWatchedByTypeViewpoint)
        
        XCTAssert(itemsWatchedByType["tv"] == 3, "\(itemsWatchedByType["tv"]!) != 3")
        XCTAssert(itemsWatchedByType["film"] == 2, "\(itemsWatchedByType["film"]!) != 2")
    }

    func testFacebookEvents() {
        /*
         Use Case = On Tuesday I Liked Something on Facebook
         Data = Tuesday | Gary | Facebook Liked | Source=Tracey
         Chart = Track My Facebook Activity
         Chart = What Type of Facebook User Am I?
         */

        let eventsModel = EventsModel(managedContext: self.managedObjectContext!)
        
        let startingEventCount = eventsModel.events?.count
        
        let meNoun = eventsModel.findNoun(id: "me")
        
        let interactVerb = eventsModel.findVerb(id: "interact")
        
        let accountProperty = eventsModel.findProperty(id: "account")
        let typeProperty = eventsModel.findProperty(id: "type")
        let sourceProperty = eventsModel.findProperty(id: "source")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat
        
        var testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "01-05-2017 00:00")!, primaryNoun: meNoun!, verb: interactVerb!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "facebook", property: accountProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "like", property: typeProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "Pingi", property: sourceProperty!)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "02-05-2017 00:00")!, primaryNoun: meNoun!, verb: interactVerb!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "facebook", property: accountProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "like", property: typeProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "Renee", property: sourceProperty!)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "02-05-2017 00:00")!, primaryNoun: meNoun!, verb: interactVerb!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "facebook", property: accountProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "like", property: typeProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "Pingi", property: sourceProperty!)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "03-05-2017 00:00")!, primaryNoun: meNoun!, verb: interactVerb!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "facebook", property: accountProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "post", property: typeProperty!)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "04-05-2017 00:00")!, primaryNoun: meNoun!, verb: interactVerb!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "facebook", property: accountProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "post", property: typeProperty!)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "04-05-2017 00:00")!, primaryNoun: meNoun!, verb: interactVerb!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "facebook", property: accountProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "share", property: typeProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "Renee", property: sourceProperty!)
        
        testEvent = eventsModel.createEvent(when: dateFormatter.date(from: "05-05-2017 00:00")!, primaryNoun: meNoun!, verb: interactVerb!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "facebook", property: accountProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "like", property: typeProperty!)
        _ = eventsModel.addAttribute(event: testEvent, attributeValue: "Pingi", property: sourceProperty!)
        
        XCTAssert(eventsModel.events?.count == startingEventCount! + 7)
        
        let interactionsByMonthViewpoint = EventsModel.Viewpoint(viewpointVerb: interactVerb!)
        let interactionsByMonth = eventsModel.getChartData(viewpoint: interactionsByMonthViewpoint)
        
        XCTAssert(interactionsByMonth["May.2017"] == 7, "\(interactionsByMonth["May.2017"]!) != 7")
        
        
        let interactionsByTypeViewpoint = EventsModel.Viewpoint(viewpointVerb: interactVerb!, viewpointDimension: typeProperty!)
        let interactionsByType = eventsModel.getChartData(viewpoint: interactionsByTypeViewpoint)
        
        XCTAssert(interactionsByType["like"] == 4, "\(interactionsByType["like"]!) != 4")
        XCTAssert(interactionsByType["post"] == 2, "\(interactionsByType["post"]!) != 2")
        
    }

}
