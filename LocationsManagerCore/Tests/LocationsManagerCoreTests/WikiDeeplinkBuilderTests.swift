//
//  WikiDeeplinkBuilderTests.swift
//  
//
//  Created by Sergey Petrachkov on 06.03.2023.
//

import XCTest
import struct CoreLocation.CLLocationCoordinate2D
@testable import Domain

final class WikiDeeplinkBuilderTests: XCTestCase {

    func testDeeplinkWithoutLocationName() {
        let buildDeeplink = WikiDeeplinkBuilder()
        let deeplink = buildDeeplink(location: Location(coordinate: CLLocationCoordinate2D(latitude: 0.999239, longitude: 0.123450)))
        XCTAssertEqual(deeplink, URL(string: "wikipedia://places?WMFArticleURL=https://override&WMFPage=Places&lat=0.999239&lon=0.12345"))
    }

    func testDeeplinkWithLocationName() {
        let buildDeeplink = WikiDeeplinkBuilder()
        let deeplink = buildDeeplink(location: Location(name: "Dummy", coordinate: CLLocationCoordinate2D(latitude: 0.999239, longitude: 0.123450)))
        XCTAssertEqual(deeplink, URL(string: "wikipedia://places?WMFArticleURL=https://override&WMFPage=Places&location_name=Dummy&lat=0.999239&lon=0.12345"))
    }
}
