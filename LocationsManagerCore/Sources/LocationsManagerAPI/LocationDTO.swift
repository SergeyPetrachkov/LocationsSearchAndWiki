//
//  LocationDTO.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation

public struct LocationDTO: Decodable {
    public let name: String?
    public let lat: Double
    public let long: Double
}
