//
//  WikiDeeplinkBuilder.swift
//  
//
//  Created by Sergey Petrachkov on 06.03.2023.
//

import Foundation

/// This is a nominal type that servers only one purpose: build a deeplink to open the Wiki app.
///
/// **Important:**
/// Since iOS 16 there's new API to manage query items and we can do:
///
///  `url.append(queryItems: [URLQueryItem(name: "location_name", value: locationName))`
///
///  but that would be too easy, right? So here's a shiny new version and a super simple analogue (not without possible issues).
///  Just to demonstrate that we can adopt newer API but at the same time keeping the interfaces that can be worked with from older targets.
public struct WikiDeeplinkBuilder {

    public init() { }

    public func callAsFunction(location: Location) -> URL? {
        if #available(iOS 16.0, *) {
            var url: URL? = URL(string: "wikipedia://places?WMFArticleURL=https://override&WMFPage=Places")
            if let locationName = location.name {
                url?.append(queryItems: [URLQueryItem(name: "location_name", value: locationName)])
            }
            url?.append(queryItems: [URLQueryItem(name: "lat", value: "\(location.coordinate.latitude)"), URLQueryItem(name: "lon", value: "\(location.coordinate.longitude)")])
            return url
        } else {
            var string = "wikipedia://places?WMFArticleURL=https://override&WMFPage=Places&"
            if let locationName = location.name {
                string += "location_name=\(locationName)&"
            }
            string += "lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
            return URL(string: string)
        }
    }
}
