//
//  LocationSearchViewModel.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation

public protocol LocationSearchViewModelLogic: AnyObject, ViewModelCycle {}

@MainActor
public final class LocationSearchViewModel: LocationSearchViewModelLogic {

    public init() {
        
    }

    public func start() async {

    }

    public func pause() async {
        
    }
}
