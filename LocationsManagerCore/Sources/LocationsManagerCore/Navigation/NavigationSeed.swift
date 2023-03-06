//
//  NavigationSeed.swift
//  
//
//  Created by Sergey Petrachkov on 06.03.2023.
//

/// An enum that descibes existing screens in our app.
///
/// This can potentially be used to use as a part of restoration flow or combining with custom navigation solutions to build a navigation tree.
/// It can also be used for analytics purposes, where we need to know where we are coming from.
public enum NavigationSeed {
    case locationsList
    case locationSearch
}
