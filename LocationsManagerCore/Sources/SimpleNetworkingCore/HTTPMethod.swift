//
//  HTTPMethod.swift
//  
//
//  Created by Sergey Petrachkov
//

import Foundation

/// Strings for HTTP methods in one place as an enum
public enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}
