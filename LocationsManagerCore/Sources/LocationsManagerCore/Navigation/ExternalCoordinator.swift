//
//  ExternalCoordinator.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Domain
import SiberianMacros

/// An abstraction serving to be a gateway for our locations into other apps.
@AutoMockable
public protocol ExternalCoordinator {
    func show(location: Location)
}
