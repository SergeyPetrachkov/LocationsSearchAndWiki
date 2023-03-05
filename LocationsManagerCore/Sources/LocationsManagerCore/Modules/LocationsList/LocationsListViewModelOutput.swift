//
//  LocationsListViewModelOutput.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation
import Combine
import Domain

public protocol LocationsListViewModelOutputEmitting {
    var locationsSubject: CurrentValueSubject<[LocationOrigin: [Location]], Never> { get }
    var loadingSubject: PassthroughSubject<Bool, Never> { get }
    var errorSubject: PassthroughSubject<Error, Never> { get }
}
