// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - External Targets
let automocableProductDependency = Target.Dependency.product(name: "SiberianMacros", package: "SiberianMacros")

// MARK: - Local Targets

let networkingCore = "SimpleNetworkingCore"
let networkingCoreTarget = Target.target(
    name: networkingCore,
    path: path(for: networkingCore)
)
let networkingCoreDependency = Target.Dependency.target(name: networkingCore)

let locationsManagerAPI = "LocationsManagerAPI"
let locationsManagerAPITarget = Target.target(
    name: locationsManagerAPI,
    dependencies: [networkingCoreDependency],
    path: path(for: locationsManagerAPI)
)
let locationsManagerAPIDependency = Target.Dependency.target(name: locationsManagerAPI)

let domain = "Domain"
let domainTarget = Target.target(
    name: domain,
    path: path(for: domain)
)
let domainDependency = Target.Dependency.target(name: domain)

let geocoding = "Geocoding"
let geocodingTarget = Target.target(
    name: geocoding,
    dependencies: [
        domainDependency,
        automocableProductDependency
    ],
    path: path(for: geocoding)
)
let geocodingDependency = Target.Dependency.target(name: geocoding)

let logger = "Logger"
let loggerTarget = Target.target(
    name: logger,
    dependencies: [
        automocableProductDependency
    ],
    path: path(for: logger)
)
let loggerDependency = Target.Dependency.target(name: logger)

/// This is an Umbrella target that has everything glued together
let locationsManagerCore = "LocationsManagerCore"
let locationsManagerCoreTarget = Target.target(
    name: locationsManagerCore,
    dependencies: [
        locationsManagerAPIDependency,
        domainDependency,
        loggerDependency,
        geocodingDependency,
        automocableProductDependency
    ],
    path: path(for: locationsManagerCore)
)
let locationsManagerCoreDependency = Target.Dependency.target(name: locationsManagerCore)

// MARK: - Test targets

let locationsManagerCoreTestsTarget = Target.testTarget(
    name: "LocationsManagerCoreTests",
    dependencies: [locationsManagerCoreDependency]
)

// MARK: - Package manifest
let package = Package(
    name: "LocationsManagerCore",
    platforms: [
        .iOS(.v15), // this is this high because I used keyboardLayoutGuide in LocationSearchViewController to save time implementing observing keyboard myself
        .macOS(.v13),
    ],
    products: [
        .library(
            name: locationsManagerCore,
            targets: [locationsManagerCore, logger, locationsManagerAPI, domain]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0"),
        .package(url: "https://github.com/SergeyPetrachkov/SiberianMacros", branch: "main")
    ],
    targets: [
        domainTarget,
        geocodingTarget,
        loggerTarget,
        networkingCoreTarget,
        locationsManagerAPITarget,
        locationsManagerCoreTarget,
        // tests go under this line
        locationsManagerCoreTestsTarget,
    ]
)

// MARK: - Private helpers

func path(for target: String) -> String {
    "Sources/\(target)"
}
