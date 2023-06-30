//
//  Logger.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import SiberianMacros

/// An interface for any logging entity
@AutoMockable
public protocol Logging {
    /// Log an event defined within the system
    func log(event: LocationsManagerEvent)
    /// Log any string if needed
    func log(_ string: String)
    /// Log errors
    func error(_ error: Error)
}
