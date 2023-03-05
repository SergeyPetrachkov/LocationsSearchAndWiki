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

struct WikiDeeplinkBuilder {

    func callAsFunction(location: Location) -> URL? {
        var url: URL? = URL(string: "wikipedia://places")

        if let locationName = location.name {
            url?.append(queryItems: [URLQueryItem(name: "location_name", value: locationName)])
        }
        url?.append(queryItems: [URLQueryItem(name: "lat", value: "\(location.coordinate.latitude)"), URLQueryItem(name: "lon", value: "\(location.coordinate.longitude)")])
        return url
    }
}

struct WikiAppCoordinator: ExternalCoordinator {

    let logger: Logging

    func show(location: Location) {
        logger.log(event: .showLocation(name: location.name, coordinate: location.coordinate))
        let buildWikiDeeplink = WikiDeeplinkBuilder()
        if let url = buildWikiDeeplink(location: location) {
            UIApplication.shared.open(url)
        }
    }
}
