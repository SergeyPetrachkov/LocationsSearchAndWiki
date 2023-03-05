//
//  File.swift
//  
//
//  Created by Sergey Petrachkov on 05.03.2023.
//

import XCTest
import struct CoreLocation.CLLocationCoordinate2D
@testable import Domain

final class CLLocationCoordinateStringTests: XCTestCase {
    func testZeroIsland() throws {
        let string = try XCTUnwrap(Location(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)).readableCoordinates)
        XCTAssert("0°0'N 0°0'E" == string, "Actual string is: \(string)")
    }

    func testAmsterdam() throws {
        let string = try XCTUnwrap(Location(coordinate: CLLocationCoordinate2D(latitude: 52.3676, longitude: 4.9041)).readableCoordinates)
        XCTAssert("52°22'N 4°54'E" == string, "Actual string is: \(string)")
    }

    func testNewYork() throws {
        let string = try XCTUnwrap(Location(coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)).readableCoordinates)
        XCTAssert("40°42'N 74°0'W" == string, "Actual string is: \(string)")
    }

    func testMelbourne() throws {
        let string = try XCTUnwrap(Location(coordinate: CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631)).readableCoordinates)
        XCTAssert("37°48'S 144°57'E" == string, "Actual string is: \(string)")
    }

    func testMinus180() throws {
        let string = try XCTUnwrap(Location(coordinate: CLLocationCoordinate2D(latitude: -180, longitude: -180)).readableCoordinates)
        XCTAssert("180°0'S 180°0'W" == string, "Actual string is: \(string)")
    }
}
