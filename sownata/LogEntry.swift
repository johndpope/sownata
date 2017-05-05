//
//  LogEntry.swift
//  sownata
//
//  Created by Gary Joy on 26/04/2016.
//
//

import Foundation

class LogEntry {
    
    static let EmptyDescription: String = "..."
    
    var time: String?
    var noun: String?
    var verb: String?

    var description: String {
        get {
            if validate() {
                return "\(time!) \(noun!) \(verb!)"
            }
            else {
                return LogEntry.EmptyDescription
            }
        }
    }
    
    func validate() -> Bool {
        
        print(time != nil)
        print(noun != nil)
        print(verb != nil)
        
        return time != nil && noun != nil && verb != nil
    }
    
    func clear() {
        time = nil
        noun = nil
        verb = nil
    }
    
}
