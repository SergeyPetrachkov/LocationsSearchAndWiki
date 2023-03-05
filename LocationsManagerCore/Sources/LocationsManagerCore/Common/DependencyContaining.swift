//
//  DependencyContaining.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import Logger
import LocationsManagerAPI
import Geocoding

public protocol DependencyContaining: AnyObject {
    var logger: Logging { get }
    func locationsApi() -> LocationsManagerAPIProviding
    func locationsRepository() -> LocationsRepositoryLogic
    func geocoder() -> Geocoder
    func externalCoordinator() -> ExternalCoordinator
}
