//
//  ContentType.swift
//  
//
//  Created by Sergey Petrachkov
//

import Foundation

/// Popular Content types for the API layer
public enum ContentType: String {
    case applicationJson = "application/json"
    case jsonAndTextJavascript = "application/json, text/javascript"
    case textJavascript = "text/javascript"
    case json = "Json"
}
