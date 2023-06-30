//
//  MacrosGeneratedMockTests.swift
//
//
//  Created by Sergey Petrachkov on 28.06.2023.
//

import XCTest
@testable import LocationsManagerCore
@testable import Logger
@testable import Geocoding

@MainActor
final class MacrosGeneratedMockTests: XCTestCase {

    var sut: LocationSearchCoordinator!
    var mockDependenciesContainer: MockDependencyContaining!
    var mockLogger: MockLogging!
    var mockGeocoder: MockGeocoder!
    var mockLocationsRepository: MockLocationsRepository!
    var mockExternalCoordinator: MockExternalCoordinator!
    var mockViewController: MockNavigationViewController!

    override func setUp() {
        super.setUp()
        mockLogger = MockLogging()
        mockGeocoder = MockGeocoder()
        mockLocationsRepository = MockLocationsRepository()
        mockExternalCoordinator = MockExternalCoordinator()
        mockDependenciesContainer = MockDependencyContaining()
        mockDependenciesContainer.logger = mockLogger
        mockDependenciesContainer.geocoderReturnValue = mockGeocoder
        mockDependenciesContainer.locationsUsecase = mockLocationsRepository
        mockDependenciesContainer.externalCoordinatorNavigationseedReturnValue = mockExternalCoordinator

        mockViewController = MockNavigationViewController()

        sut = LocationSearchCoordinator(
            navigationController: mockViewController,
            dependenciesContainer: mockDependenciesContainer
        )
    }

    override func tearDown() {
        mockLogger = nil
        mockGeocoder = nil
        mockLocationsRepository = nil
        mockExternalCoordinator = nil
        mockDependenciesContainer = nil

        mockViewController = nil
        super.tearDown()
    }

    func test_WhenStarted_PresentCalled() {
        sut.start()
        XCTAssert(mockViewController.presentCalled)
    }

    func test_WhenLocationShowTriggers_ExternalCoordinatorCalled() {
        sut.show(location: .init(coordinate: .init(latitude: 0, longitude: 0)))
        XCTAssert(mockExternalCoordinator.showLocationCalled)
    }

    func test_WhenCancellingSearch_PresentedControllerDismissed() {
        sut.start()
        sut.didCancelSearch()
        XCTAssertNil(mockViewController.presentedViewController)
    }
}
