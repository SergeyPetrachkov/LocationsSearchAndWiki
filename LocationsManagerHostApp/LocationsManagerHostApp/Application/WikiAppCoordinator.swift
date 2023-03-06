//
//  WikiAppCoordinator.swift
//  LocationsManager
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import UIKit
import LocationsManagerCore
import Domain
import CoreLocation
import Logger

struct WikiAppCoordinator: ExternalCoordinator {

    let logger: Logging
    let origin: NavigationSeed

    func show(location: Location) {
        // We are not waiting for the app to actually open the link. Just log it here. Given requirements from the analysts this can/should be reworked.
        logger.log(event: .showLocation(name: location.name, coordinate: location.coordinate, origin: origin == .locationsList ? .list : .search))
        let buildWikiDeeplink = WikiDeeplinkBuilder()
        if let url = buildWikiDeeplink(location: location) {
            UIApplication.shared.open(url)
        }
    }
}
