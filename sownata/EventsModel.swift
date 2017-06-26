//
//  EventsModel.swift
//  sownata
//
//  Created by Gary Joy on 24/03/2017.
//
//

import CoreData
import UIKit

class EventsModel {

    struct CoreDataConstants {
        static var Verb = "Verb"
        static var Noun = "Noun"
        static var Event = "Event"
    }
    
    var managedContext: NSManagedObjectContext? = nil

    init(managedContext: NSManagedObjectContext) {
        // IMPORTANT: You can only use this on the Main Queue (it is not thread-safe)
        // (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        self.managedContext = managedContext
    }
    
    //# MARK: - Verb
    
    public func createVerb(id: String, name: String) -> Verb {
        // TODO:  Check if the Verb already exists
        let verb = Verb(context: managedContext!)
        verb.id = id
        verb.name = name
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createVerb id=\(id) name=\(name)")
        }
        return verb
    }
    
    var verbs: [Verb]? {
        let request: NSFetchRequest<Verb> = Verb.fetchRequest()
        let verbs = try? managedContext!.fetch(request)
        return verbs
    }

    //# MARK: - Noun

    public func createNoun(id: String, name: String) -> Noun {
        // TODO:  Check if the Noun already exists
        let noun = Noun(context: managedContext!)
        noun.id = id
        noun.name = name
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createNoun id=\(id) name=\(name)")
        }
        return noun
    }

    public func findNoun(id:String) -> Noun {
        let request: NSFetchRequest<Noun> = Noun.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let nouns = try? managedContext!.fetch(request)
        
        //# TODO: - Handle Missing Noun
        return nouns![0]
    }
    
    var nouns: [Noun]? {
        let request: NSFetchRequest<Noun> = Noun.fetchRequest()
        let nouns = try? managedContext!.fetch(request)
        return nouns
    }

    //# MARK: - Measure

    public func createMeasure(id: String, name: String, verb: Verb) -> Measure {
        //# TODO: - Check if the Measure already exists
        let measure = Measure(context: managedContext!)
        measure.id = id
        measure.name = name
        measure.mutableSetValue(forKey: "verbs").add(verb)
       
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createMeasure id=\(id) name=\(name) verb=\(verb.name as Optional)")
        }
        return measure
    }
    
    //# MARK: - Value
    
    //# TODO: - Should this be part of the Event Class?
    public func addValue(event: Event, valueValue: Decimal, measure: Measure) -> Value {
        let value = Value(context: managedContext!)
        value.value = valueValue as NSDecimalNumber
        value.measure = measure
        value.event = event
        
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in addValue value=\(valueValue) measure=\(measure.name as Optional)")
        }
        return value
    }

    //# MARK: - Property
    
    public func createProperty(id: String, name: String, verb: Verb) -> Property {
        // TODO:  Check if the Property already exists
        let property = Property(context: managedContext!)
        property.id = id
        property.name = name
        property.mutableSetValue(forKey: "verbs").add(verb)
        
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createProperty id=\(id) name=\(name)")
        }
        return property
    }


    //# MARK: - Attribute
    
    //# TODO: - Should this be part of the Event Class?
    public func addAttribute(event: Event, attributeValue: String, property: Property) -> Attribute {
        let attribute = Attribute(context: managedContext!)
        attribute.attribute = attributeValue
        attribute.property = property
        attribute.event = event
        
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in addAttribute attribute=\(attributeValue) property=\(property.name as Optional)")
        }
        return attribute
    }

    //# MARK: - Event (In)

    public func createEvent(primaryNoun: Noun, verb: Verb) -> Event {
        return createEvent(when: NSDate() as Date, primaryNoun: primaryNoun, verb: verb, secondaryNoun: nil)
    }

    public func createEvent(when: Date?, primaryNoun: Noun, verb: Verb) -> Event {
        if ((when) != nil) {
            return createEvent(when: when!, primaryNoun: primaryNoun, verb: verb, secondaryNoun: nil)
        }
        else {
            return createEvent(when: NSDate() as Date, primaryNoun: primaryNoun, verb: verb, secondaryNoun: nil)
        }
    }

    public func createEvent(when: Date, primaryNoun: Noun, verb: Verb, secondaryNoun: Noun?) -> Event {
        let event = Event(context: managedContext!)
        event.setTime(time: when as NSDate)
        event.primaryNoun = primaryNoun
        event.verb = verb
        //# TODO: - Check that this is the best way to check an optional
        if ((secondaryNoun) != nil) {
            event.secondaryNoun = secondaryNoun!
        }
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createEvent noun=\(primaryNoun.name as Optional) verb=\(verb.name as Optional)")
        }
        return event
    }
    
    //# MARK: - Events (Out)
    
    public func getEventsForVerb(verb: Verb) -> Set<Event>? {
        return verb.events as? Set<Event>
    }

    public func getEventCountByMonthForVerb(verb: Verb) -> [String:Int] {
        
        var eventCounts:[String:Int] = [:]
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")

        let predicate = NSPredicate(format: "verb == %@", verb)
        request.predicate = predicate
        
        let monthExpression = NSExpression(forKeyPath: "month")
        let countExpressionDecsription = NSExpressionDescription()
        countExpressionDecsription.expression = NSExpression(forFunction: "count:", arguments: [monthExpression])
        countExpressionDecsription.name = "rowCount"
        countExpressionDecsription.expressionResultType = .integer32AttributeType
        
        request.propertiesToFetch = ["month", countExpressionDecsription]
        request.propertiesToGroupBy = ["month"]
        
        request.resultType = .dictionaryResultType
        
        let sort = NSSortDescriptor(key: "month", ascending: false)
        request.sortDescriptors = [sort]
        
        let rawResults = try? managedContext!.fetch(request) as NSArray?
        
        if let results = rawResults! as? [[String:AnyObject]] {
            for result in results {
                let month = result["month"] as? String
                let rowCount = result["rowCount"] as? Int
                eventCounts[month!] = rowCount
            }
        }
        
        return eventCounts
    }

    enum AggregateFunction: String {
        case Sum = "sum:"
        case Average = "average:"
        case Count = "count:"
    }
    
    public func getMeasureAggregateByMonthForVerb(verb: Verb, measure: Measure, aggregateFunction: AggregateFunction) -> [String:Double] {
        
        var eventCounts:[String:Double] = [:]
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Value")
        
        let predicate = NSPredicate(format: "measure = %@ AND event.verb = %@", measure, verb)
        request.predicate = predicate
        
        let aggregateExpression = NSExpression(forKeyPath: "value")
        let countExpressionDecsription = NSExpressionDescription()
        countExpressionDecsription.expression = NSExpression(forFunction: aggregateFunction.rawValue, arguments: [aggregateExpression])
        countExpressionDecsription.name = "aggregateValue"
        countExpressionDecsription.expressionResultType = .integer32AttributeType
        
        request.propertiesToFetch = ["event.month", countExpressionDecsription]
        request.propertiesToGroupBy = ["event.month"]
        
        request.resultType = .dictionaryResultType
        
        let sort = NSSortDescriptor(key: "event.month", ascending: false)
        request.sortDescriptors = [sort]
        
        let rawResults = try? managedContext!.fetch(request) as NSArray?
        
        if let results = rawResults! as? [[String:AnyObject]] {
            for result in results {
                let month = result["event.month"] as? String
                let valueSum = result["aggregateValue"] as? Double
                eventCounts[month!] = valueSum
            }
        }
        
        return eventCounts
    }

    public func getPropertyCountsForVerbBetweenDates(verb: Verb, property: Property) -> [String:Double] {
        
        var eventCounts:[String:Double] = [:]
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Attribute")
        
        let predicate = NSPredicate(format: "property = %@ AND event.verb = %@", property, verb)
        request.predicate = predicate
        
        let aggregateExpression = NSExpression(forKeyPath: "attribute")
        let countExpressionDecsription = NSExpressionDescription()
        countExpressionDecsription.expression = NSExpression(forFunction: AggregateFunction.Count.rawValue, arguments: [aggregateExpression])
        countExpressionDecsription.name = "aggregateValue"
        countExpressionDecsription.expressionResultType = .integer32AttributeType
        
        request.propertiesToFetch = ["attribute", countExpressionDecsription]
        request.propertiesToGroupBy = ["attribute"]
        
        request.resultType = .dictionaryResultType
        
        let sort = NSSortDescriptor(key: "attribute", ascending: false)
        request.sortDescriptors = [sort]
        
        let rawResults = try? managedContext!.fetch(request) as NSArray?
        
        if let results = rawResults! as? [[String:AnyObject]] {
            for result in results {
                let attribute = result["attribute"] as? String
                let valueSum = result["aggregateValue"] as? Double
                eventCounts[attribute!] = valueSum
            }
        }
        
        return eventCounts
    }

    
    //# TODO: - ?
    var events: [Event]? {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let events = try? managedContext!.fetch(request)
        return events
    }

    
}
