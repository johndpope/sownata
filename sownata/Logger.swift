//
//  Logger.swift
//  sownata
//
//  Created by Gary Joy on 05/11/2017.
//

import Foundation

enum LoggerLevel: Int {
    
    case None = 0
    case Error
    case Warning
    case Success
    case Info
    case Debug
}

class Logger {
    
    var loggerLevel: LoggerLevel = .Debug
    
    func logMessage(message: String, logLevel: LoggerLevel = .Info) {
        
        if self.loggerLevel.rawValue > LoggerLevel.None.rawValue && logLevel.rawValue <= self.loggerLevel.rawValue {
            print("\(message)")
        }
    }
    
    class var sharedInstance: Logger {
        
        struct Singleton {
            static let instance = Logger()
        }
        
        return Singleton.instance
    }
}
