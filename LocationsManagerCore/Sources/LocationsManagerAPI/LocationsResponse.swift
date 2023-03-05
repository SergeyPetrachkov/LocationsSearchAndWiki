//
//  LocationsResponse.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation

public struct LocationsResponse: Decodable {
    public let locations: [LocationDTO]
}
