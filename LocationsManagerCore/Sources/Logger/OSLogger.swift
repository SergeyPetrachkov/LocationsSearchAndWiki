//
//  OSLogger.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import OSLog

public extension OSLog {
    static let subsystem = "LocationsManager"
    static let userActivity = OSLog(subsystem: subsystem, category: "user_activity")
}

public final class OSLogger: Logging {

    public init() {}

    public func log(event: LocationsManagerEvent) {
        os_log("âšī¸ %{public}@ %{private}@", log: OSLog.userActivity, type: .info, event.name, event.parameters)
    }

    public func log(_ string: String) {
        os_log("đ¨ %{public}@", log: OSLog.userActivity, type: .debug, string)
    }

    public func error(_ error: Error) {
        os_log("â Error description: %{public}@", log: OSLog.userActivity, type: .error, "\(error.localizedDescription)")
    }
}
