//
//  NavigationSeedHolder.swift
//  
//
//  Created by Sergey Petrachkov on 06.03.2023.
//

/// Any instance that holds a navigation seed. Coordinators in our case.
public protocol NavigationSeedHolder {
    var navigationSeed: NavigationSeed { get }
}
