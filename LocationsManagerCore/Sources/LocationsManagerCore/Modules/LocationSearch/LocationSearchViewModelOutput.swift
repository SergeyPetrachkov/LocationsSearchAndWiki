//
//  LocationSearchViewModelOutput.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Combine
import Domain

public protocol LocationSearchViewModelOutput {
    var currentLocationSubject: CurrentValueSubject<Location?, Never> { get }
}
