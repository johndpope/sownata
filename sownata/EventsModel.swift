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
    
    //# MARK: - Event

    public func createEvent(noun: Noun, verb: Verb) -> Event {
        let event = Event(context: managedContext!)
        event.time = NSDate()
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
        event.time = NSDate()
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
        event.time = when as NSDate
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
        event.time = when as NSDate
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

    //# TODO: - ?
    var events: [Event]? {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let events = try? managedContext!.fetch(request)
        return events
    }

    
}
