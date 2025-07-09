//
//  Logger.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation
import os.log

protocol Logger {
    func debug(_ message: String, category: String)
    func info(_ message: String, category: String)
    func error(_ message: String, category: String)
    func warning(_ message: String, category: String)
}

class OSLogger: Logger {
    private let subsystem: String
    
    init(subsystem: String = "com.myaccount.app") {
        self.subsystem = subsystem
    }
    
    func debug(_ message: String, category: String = "General") {
        let log = OSLog(subsystem: subsystem, category: category)
        os_log("%@", log: log, type: .debug, message)
    }
    
    func info(_ message: String, category: String = "General") {
        let log = OSLog(subsystem: subsystem, category: category)
        os_log("%@", log: log, type: .info, message)
    }
    
    func error(_ message: String, category: String = "General") {
        let log = OSLog(subsystem: subsystem, category: category)
        os_log("%@", log: log, type: .error, message)
    }
    
    func warning(_ message: String, category: String = "General") {
        let log = OSLog(subsystem: subsystem, category: category)
        os_log("%@", log: log, type: .default, message)
    }
}

// Global logger instance
let logger: Logger = OSLogger()

// Convenience functions for logging
func logDebug(_ message: String, category: String = "General") {
    logger.debug(message, category: category)
}

func logInfo(_ message: String, category: String = "General") {
    logger.info(message, category: category)
}

func logError(_ message: String, category: String = "General") {
    logger.error(message, category: category)
}

func logWarning(_ message: String, category: String = "General") {
    logger.warning(message, category: category)
}
