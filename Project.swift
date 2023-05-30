import ProjectDescription

let project = Project(
    name: "LocationsManager-Generated",
    packages: [.local(path: "LocationsManagerCore")],
    targets: [
        Target(
            name: "LocationsManager",
            platform: .iOS,
            product: .app,
            bundleId: "com.petrachkov.locationsmanagerhostapp",
            infoPlist: .file(path: "LocationsManagerHostApp/LocationsManagerHostApp/Info.plist"),
            sources: ["LocationsManagerHostApp/**"],
            dependencies: [.package(product: "LocationsManagerCore")],
            settings: .settings(configurations: [.debug(name: "Debug", xcconfig: .init("LocationsManagerHostApp/LocationsManagerHostApp/Configs/LocationsManager.xcconfig"))])
        ),
    ]
)
