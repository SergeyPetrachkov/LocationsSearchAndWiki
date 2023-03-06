//
//  UnitedLogger.swift
//  LocationsManager
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Logger

/// This is a facade to accumulate different log destinations and provide a unified interface.
///
/// If you need to log stuff to Mixpanel/Sentry/Firebase/Appsflyer/etc, add a new destination here.
final class UnitedLogs: Logging {

    private lazy var destinations: [Logger.Logging] = [OSLogger()]

    func log(event: Logger.LocationsManagerEvent) {
        destinations.forEach { destination in
            destination.log(event: event)
        }
    }

    func log(_ string: String) {
        destinations.forEach { destination in
            destination.log(string)
        }
    }

    func error(_ error: Error) {
        destinations.forEach { destination in
            destination.error(error)
        }
    }
}
