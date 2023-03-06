//
//  SimpleUserLocationsStorage.swift
//  
//
//  Created by Sergey Petrachkov on 06.03.2023.
//

import XCTest
import Foundation
import Combine
@testable import LocationsManagerCore

final class SimpleUserLocationsStorageTests: XCTestCase {

    var userDefaults: UserDefaults!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "temp")!
    }

    override func tearDown() {
        super.tearDown()
        userDefaults.removeObject(forKey: "user_locations")
    }

    func makeSUT() -> SimpleUserLocationsStorage {
        SimpleUserLocationsStorage(defaults: userDefaults)
    }

    func testSavingOneLocationWorks() {
        let sut = makeSUT()
        XCTAssert(sut.getLocations().isEmpty, "Storage is not empty before testing!")
        let dummyLocation = StorableLocation(name: "DummyName", latitude: 0, longitude: 0)
        sut.saveLocation(dummyLocation)
        XCTAssert(sut.getLocations().count == 1, "There's nothing in the storage!")
    }

    func testSavingTheSameLocationMultipleTimesDoesntHappen() {
        let sut = makeSUT()
        XCTAssert(sut.getLocations().isEmpty, "Storage is not empty before testing!")
        let dummyLocation = StorableLocation(name: "DummyName", latitude: 0, longitude: 0)
        sut.saveLocation(dummyLocation)
        sut.saveLocation(dummyLocation)
        XCTAssert(sut.getLocations().count == 1, "The storage is corrupted!")
    }

    func testStorageShouldPublishNewLocation() throws {
        let sut = makeSUT()
        let dummyLocation = StorableLocation(name: "DummyName", latitude: 0, longitude: 0)
        var receivedLocation: StorableLocation?
        sut.newLocationPublisher.sink { location in
            receivedLocation = location
        }
        .store(in: &cancellables)
        sut.saveLocation(dummyLocation)
        let unwrappedReceivedLocation = try XCTUnwrap(receivedLocation)
        XCTAssertEqual(unwrappedReceivedLocation, dummyLocation)
    }

    func testStorageShouldPublishOnlyUniqueLocations() throws {
        let sut = makeSUT()
        let dummyLocation = StorableLocation(name: "DummyName", latitude: 0, longitude: 0)
        let anotherDummyLocation = StorableLocation(name: "AnotherDummyName", latitude: 0, longitude: 0)
        var receivedLocations = [StorableLocation]()
        sut.newLocationPublisher.sink { location in
            receivedLocations.append(location)
        }
        .store(in: &cancellables)
        sut.saveLocation(dummyLocation)
        sut.saveLocation(dummyLocation)
        sut.saveLocation(dummyLocation)
        sut.saveLocation(anotherDummyLocation)
        XCTAssertEqual(receivedLocations, [dummyLocation, anotherDummyLocation])
    }
}
