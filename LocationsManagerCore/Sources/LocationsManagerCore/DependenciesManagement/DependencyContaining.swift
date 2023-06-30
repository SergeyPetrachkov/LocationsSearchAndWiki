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
import SiberianMacros

/// The protocol describes an interface for out system dependencies container
@AutoMockable
public protocol DependencyContaining: AnyObject {
    /// Any logger or a United logger with all the destinations (OSLog, Mixpanel, Firebase, Facebook, Sentry, you name it)
    var logger: Logging { get }
    /// Centralized way to have Locations usecase. It could have been a factory method, but we use this to handle data stream,
    /// and this entity could use some separation of concerns ideally.
    var locationsUsecase: LocationsRepository { get }
    /// The API calls handling entity
    func locationsApi() -> LocationsManagerAPIProviding
    /// Geocoder used by the app
    func geocoder() -> Geocoder
    /// Build an entity that will handle the navigation outside of our app
    func externalCoordinator(navigationSeed: NavigationSeed) -> ExternalCoordinator
}
