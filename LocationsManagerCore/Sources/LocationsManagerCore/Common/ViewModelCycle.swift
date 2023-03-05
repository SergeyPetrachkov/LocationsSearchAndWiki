//
//  File.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import Foundation

public protocol ViewModelCycle {
    func start() async
    func pause() async
}
