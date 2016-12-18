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
    
    var category: String = "Test"
    var verb: String?
    var noun: String = "I"
    var time: Date = Date()
    var data: [String] = []

    var description: String {
        get {
            if verb != nil {
                
                let formatter = DateFormatter()
                formatter.dateStyle = DateFormatter.Style.short
                formatter.timeStyle = .short
                let dateString = formatter.string(from: time)
                
                return "On \(dateString) \r\n \(noun) \(verb!) \r\n \(data)"
            } else {
                return LogEntry.EmptyDescription
            }
        }
    }
    
    func clear() {
        verb = nil
        data = []
    }
    
}
