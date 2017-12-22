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

    var empty: Bool {
        if let verbCount = verbs?.count {
            return verbCount == 0
        }
        else {
            return false
        }
    }
    
    init(managedContext: NSManagedObjectContext) {
        // IMPORTANT: You can only use this on the Main Queue (it is not thread-safe)
        // (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        self.managedContext = managedContext
        
        if empty {
            initialiseMetadata()
        }
    }
    
    private func initialiseMetadata() {

        Logger.sharedInstance.logMessage(message: "Creating Default Metadata", logLevel: .Info)

        let runVerb = createVerb(id: "run", name: "run")
        let weighVerb = createVerb(id: "weigh", name: "weigh")
        let indulgeVerb = createVerb(id: "indulge", name: "indulge")
         _ = createVerb(id: "clean", name: "clean")
         let workVerb = createVerb(id: "work", name: "work")
         let watchVerb = createVerb(id: "watch", name: "watch")
         let interactVerb = createVerb(id: "interact", name: "interact")

        _ = createNoun(id: "me", name: "me", pronoun: true)

        _ = createNoun(id: "cake", name: "cake")
        _ = createNoun(id: "toilet", name: "toilet")

        _ = createMeasure(id: "km", name: "km", verb: runVerb)
        _ = createMeasure(id: "minutes", name: "minutes", verb: runVerb)
        _ = createMeasure(id: "kg", name: "kg", verb: weighVerb)
        _ = createMeasure(id: "hours", name: "hours", verb: workVerb)
        _ = createMeasure(id: "hours", name: "hours", verb: watchVerb) // This should add watchVerb to the existing Measure, rather than create a new Measure

        _ = createProperty(id: "source", name: "source", verb: interactVerb)
        _ = createProperty(id: "source", name: "source", verb: watchVerb) // This should add watchVerb to the existing Property, rather than create a new Property
        _ = createProperty(id: "type", name: "type", verb: interactVerb)
        _ = createProperty(id: "type", name: "type", verb: watchVerb) // This should add watchVerb to the existing Property, rather than create a new Property
        _ = createProperty(id: "name", name: "name", verb: watchVerb)
        _ = createProperty(id: "account", name: "account", verb: interactVerb)
        _ = createProperty(id: "type", name: "type", verb: indulgeVerb) // This should add indulgeVerb to the existing Property, rather than create a new Property

    }
    
    //# MARK: - Verb
    
    public func createVerb(id: String, name: String) -> Verb {
        if let existingVerb = findVerb(id: id) {
            Logger.sharedInstance.logMessage(message: "The \(id) Verb already exists", logLevel: .Warning)
            return existingVerb
        }
        else {
            let verb = Verb(context: managedContext!)
            verb.id = id
            verb.name = name
            do {
                try managedContext!.save()
                Logger.sharedInstance.logMessage(message: "The \(id) Verb has been created", logLevel: .Info)
            }
            catch {
                fatalError("Unresolved error in createVerb id=\(id) name=\(name)")
            }
            return verb
        }
    }
    
    public func findVerb(id:String) -> Verb? {
        let request: NSFetchRequest<Verb> = Verb.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let verbs = try? managedContext!.fetch(request)
        if verbs?.count == 0 {
            return nil
        }
        else {
            return verbs?[0]
        }
    }

    var verbs: [Verb]? {
        let request: NSFetchRequest<Verb> = Verb.fetchRequest()
        let verbs = try? managedContext!.fetch(request)
        return verbs
    }

    //# MARK: - Noun

    public func createNoun(id: String, name: String, pronoun: Bool = false) -> Noun {
        if let existingNoun = findNoun(id: id) {
            Logger.sharedInstance.logMessage(message: "The \(id) Noun already exists", logLevel: .Warning)
            return existingNoun
        }
        else {
            let noun = Noun(context: managedContext!)
            noun.id = id
            noun.name = name
            noun.pronoun = pronoun
            do {
                try managedContext!.save()
                Logger.sharedInstance.logMessage(message: "The \(id) Noun has been created", logLevel: .Info)
            }
            catch {
                fatalError("Unresolved error in createNoun id=\(id) name=\(name)")
            }
            return noun
        }
    }

    public func findNoun(id:String) -> Noun? {
        let request: NSFetchRequest<Noun> = Noun.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let nouns = try? managedContext!.fetch(request)
        if nouns?.count == 0 {
            return nil
        }
        else {
            return nouns?[0]
        }
    }
    
    var nouns: [Noun]? {
        let request: NSFetchRequest<Noun> = Noun.fetchRequest()
        let nouns = try? managedContext!.fetch(request)
        return nouns
    }

    var pronouns: [Noun]? {
        let request: NSFetchRequest<Noun> = Noun.fetchRequest()
        request.predicate = NSPredicate(format: "pronoun == %@", NSNumber(value: true))
        let pronouns = try? managedContext!.fetch(request)
        return pronouns
    }

    //# MARK: - Measure
    public func createMeasure(id: String, name: String, verb: Verb) -> Measure {
        if let existingMeasure = findMeasure(id: id) {
            Logger.sharedInstance.logMessage(message: "The \(id) Measure already exists", logLevel: .Warning)
            //# TODO: - May still need to add the Verb...
            return existingMeasure
        }
        else {
            let measure = Measure(context: managedContext!)
            measure.id = id
            measure.name = name
            measure.mutableSetValue(forKey: "verbs").add(verb)
            
            do {
                try managedContext!.save()
                Logger.sharedInstance.logMessage(message: "The \(id) Measure has been created", logLevel: .Info)
            }
            catch {
                fatalError("Unresolved error in createMeasure id=\(id) name=\(name) verb=\(verb.name as Optional)")
            }
            return measure
        }
    }
    
    public func findMeasure(id:String) -> Measure? {
        let request: NSFetchRequest<Measure> = Measure.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let measures = try? managedContext!.fetch(request)
        if measures?.count == 0 {
            return nil
        }
        else {
            return measures?[0]
        }
    }
    
    //# MARK: - Value
    
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
        if let existingProperty = findProperty(id: id) {
            Logger.sharedInstance.logMessage(message: "The \(id) Property already exists", logLevel: .Warning)
            //# TODO: - May still need to add the Verb...
            return existingProperty
        }
        else {
            let property = Property(context: managedContext!)
            property.id = id
            property.name = name
            property.mutableSetValue(forKey: "verbs").add(verb)
            
            do {
                try managedContext!.save()
                Logger.sharedInstance.logMessage(message: "The \(id) Property has been created", logLevel: .Info)
            }
            catch {
                fatalError("Unresolved error in createProperty id=\(id) name=\(name)")
            }
            return property
        }
    }

    public func findProperty(id:String) -> Property? {
        let request: NSFetchRequest<Property> = Property.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let properties = try? managedContext!.fetch(request)
        if properties?.count == 0 {
            return nil
        }
        else {
            return properties?[0]
        }
    }

    //# MARK: - Attribute
    
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

    public func createEvent(when: Date, primaryNoun: Noun, verb: Verb, secondaryNoun: Noun? = nil) -> Event {
        let event = Event(context: managedContext!)
        event.setTime(time: when)
        event.primaryNoun = primaryNoun
        event.verb = verb
        if secondaryNoun != nil {
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

    enum AggregateFunction: String {
        case Sum = "sum:"
        case Average = "average:"
        case Count = "count:"
    }
    
    enum TimeGrouping: String {
        case Month = "event.month"
        case Year = "event.year"
    }
   
    class Viewpoint : CustomStringConvertible {

        //# TODO: - Add support for TimeGrouping...

        var dimension: NSManagedObject?
        var time: TimeGrouping?
        var function: AggregateFunction?
        var verb: Verb?
        
        init(viewpointVerb: Verb) {
            verb = viewpointVerb
            time = TimeGrouping.Month
        }
        init(viewpointVerb: Verb, viewpointDimension: Property) {
            verb = viewpointVerb
            dimension = viewpointDimension
            time = TimeGrouping.Month // This is misleading...
        }
        init(viewpointVerb: Verb, viewpointDimension: Measure, viewpointFunction: AggregateFunction) {
            verb = viewpointVerb
            dimension = viewpointDimension
            time = TimeGrouping.Month
            function = viewpointFunction
        }
        public var description: String {
            //# TODO: - Implement Me!
            return "?"
        }
    }
    
    public func getChartData(viewpoint: Viewpoint) -> [String:Double] {
        
        //# TODO: - Add support for Start and End Event Dates...

        var eventCounts:[String:Double] = [:]
        
        switch viewpoint {
        case _ where viewpoint.dimension is Property:
            eventCounts = getPropertyCountsForVerb(verb: viewpoint.verb!, property: viewpoint.dimension as! Property)
        case _ where viewpoint.dimension is Measure:
            eventCounts = getMeasureAggregateByTimeGroupingForVerb(measure: viewpoint.dimension as! Measure, aggregateFunction: viewpoint.function!, timeGrouping: viewpoint.time!, verb: viewpoint.verb!)
        default:
            eventCounts = getEventCountByTimeGroupingForVerb(timeGrouping: viewpoint.time!, verb: viewpoint.verb!)
        }
        
        return eventCounts
    }
    
    private func getEventCountByTimeGroupingForVerb(timeGrouping: TimeGrouping, verb: Verb) -> [String:Double] {
        
        //# TODO: - Add support for TimeGrouping...
        
        var eventCounts:[String:Double] = [:]
        
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
                let rowCount = result["rowCount"] as? Double
                eventCounts[month!] = rowCount
            }
        }
        
        return eventCounts
    }
    
    private func getMeasureAggregateByTimeGroupingForVerb(measure: Measure, aggregateFunction: AggregateFunction, timeGrouping: TimeGrouping ,verb: Verb) -> [String:Double] {
        
        //# TODO: - Add support for TimeGrouping...

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

    private func getPropertyCountsForVerb(verb: Verb, property: Property) -> [String:Double] {
        
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

    // TODO:  Create a getTableData() function...
    
    //# TODO: - ?
    var events: [Event]? {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let events = try? managedContext!.fetch(request)
        return events
    }

    
}
