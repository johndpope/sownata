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
        
        // TODO: Handle Missing Noun
        return nouns![0]
    }
    
    var nouns: [Noun]? {
        let request: NSFetchRequest<Noun> = Noun.fetchRequest()
        let nouns = try? managedContext!.fetch(request)
        return nouns
    }

    //# MARK: - Measure

    public func createMeasure(id: String, name: String, verb: Verb) -> Measure {
        // TODO:  Check if the Measure already exists
        let measure = Measure(context: managedContext!)
        measure.id = id
        measure.name = name
        measure.mutableSetValue(forKey: "verbs").add(verb)
       
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createMeasure id=\(id) name=\(name)")
        }
        return measure
    }
    
    //# MARK: - Value
    
    public func createValue(valueValue: Decimal, measure: Measure) -> Value {
        let value = Value(context: managedContext!)
        value.value = valueValue as NSDecimalNumber
        value.measure = measure
        
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createValue value=\(value)")
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
    
    public func createAttribute(attributeValue: String, property: Property) -> Attribute {
        let attribute = Attribute(context: managedContext!)
        attribute.attribute = attributeValue
        attribute.property = property
        
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createAttribute attribute=\(attributeValue)")
        }
        return attribute
    }

    //# MARK: - Event (In)

    public func createEvent(noun: Noun, verb: Verb) -> Event {
        let event = Event(context: managedContext!)
        event.setTime(time: NSDate())
        event.primaryNoun = noun
        event.verb = verb
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createEvent noun=\(String(describing: noun.name)) verb=\(String(describing: verb.name))")
        }
        return event
    }

    public func createEvent(primaryNoun: Noun, verb: Verb, secondaryNoun: Noun) -> Event {
        let event = Event(context: managedContext!)
        event.setTime(time: NSDate())
        event.primaryNoun = primaryNoun
        event.verb = verb
        event.secondaryNoun = secondaryNoun
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createEvent primaryNoun=\(String(describing: primaryNoun.name)) verb=\(String(describing: verb.name)) secondaryNoun=\(String(describing: secondaryNoun.name))")
        }
        return event
    }

    public func createEvent(when: Date, primaryNoun: Noun, verb: Verb, secondaryNoun: Noun) -> Event {
        let event = Event(context: managedContext!)
        event.setTime(time: when as NSDate)
        event.primaryNoun = primaryNoun
        event.verb = verb
        event.secondaryNoun = secondaryNoun
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createEvent when=\(String(describing: when.description)) primaryNoun=\(String(describing: primaryNoun.name)) verb=\(String(describing: verb.name)) secondaryNoun=\(String(describing: secondaryNoun.name))")
        }
        return event
    }

    public func createEvent(when: Date, primaryNoun: Noun, verb: Verb, value: Value) -> Event {
        let event = Event(context: managedContext!)
        event.setTime(time: when as NSDate)
        event.primaryNoun = primaryNoun
        event.verb = verb
        event.mutableSetValue(forKey: "values").add(value)
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createEvent primaryNoun=\(String(describing: primaryNoun.name)) verb=\(String(describing: verb.name)) value=\(String(describing: value.value))")
        }
        return event
    }

    public func createEvent(when: Date, primaryNoun: Noun, verb: Verb, values: [Value]) -> Event {
        let event = Event(context: managedContext!)
        event.setTime(time: when as NSDate)
        event.primaryNoun = primaryNoun
        event.verb = verb
        for value in values {
            event.mutableSetValue(forKey: "values").add(value)
        }
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createEvent primaryNoun=\(String(describing: primaryNoun.name)) verb=\(String(describing: verb.name)) values=\(String(describing: values))")
        }
        return event
    }

    public func createEvent(when: Date, primaryNoun: Noun, verb: Verb, values: [Value], attributes: [Attribute]) -> Event {
        let event = Event(context: managedContext!)
        event.setTime(time: when as NSDate)
        event.primaryNoun = primaryNoun
        event.verb = verb
        for value in values {
            event.mutableSetValue(forKey: "values").add(value)
        }
        for attribute in attributes {
            event.mutableSetValue(forKey: "attributes").add(attribute)
        }
        do {
            try managedContext!.save()
        }
        catch {
            fatalError("Unresolved error in createEvent primaryNoun=\(String(describing: primaryNoun.name)) verb=\(String(describing: verb.name)) values=\(String(describing: values)) attributes=\(String(describing: attributes))")
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

//    public func getMeasureSumByMonthForVerb(verb: Verb, measure: Measure) -> [String:Double] {
//        
//        var eventCounts:[String:Double] = [:]
//        
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Value")
//        
//        let predicate = NSPredicate(format: "measure = %@", measure)
//        request.predicate = predicate
//        
//        let sumExpression = NSExpression(forKeyPath: "value")
//        let countExpressionDecsription = NSExpressionDescription()
//        countExpressionDecsription.expression = NSExpression(forFunction: "sum:", arguments: [sumExpression])
//        countExpressionDecsription.name = "valueSum"
//        countExpressionDecsription.expressionResultType = .integer32AttributeType
//        
//        request.propertiesToFetch = ["events.month", countExpressionDecsription]
//        request.propertiesToGroupBy = ["events.month"]
//        
//        request.resultType = .dictionaryResultType
//        
//        let sort = NSSortDescriptor(key: "month", ascending: false)
//        request.sortDescriptors = [sort]
//        
//        let rawResults = try? managedContext!.fetch(request) as NSArray?
//        
//        if let results = rawResults! as? [[String:AnyObject]] {
//            for result in results {
//                let month = result["month"] as? String
//                let valueSum = result["valueSum"] as? Double
//                eventCounts[month!] = valueSum
//            }
//        }
//        
//        return eventCounts
//    }

    //# TODO: - ?
    var events: [Event]? {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let events = try? managedContext!.fetch(request)
        return events
    }

    
}
