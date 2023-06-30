import ProjectDescription

let debugConfiguration: Configuration = .debug(
    name: "Debug",
    xcconfig: .relativeToRoot("LocationsManagerHostApp/LocationsManagerHostApp/Configs/LocationsManager.xcconfig")
)

let debugScheme = Scheme(
    name: "LocationsManager-Debug",
    shared: true,
    buildAction: .buildAction(targets: [TargetReference(stringLiteral: "LocationsManager")]),
    testAction: .testPlans([], configuration: .configuration("Debug")),
    runAction: .runAction(configuration: .configuration("Debug")),
    archiveAction: .archiveAction(configuration: .configuration("Debug")),
    profileAction: .profileAction(configuration: .configuration("Debug")),
    analyzeAction: .analyzeAction(configuration: .configuration("Debug"))
)

let settings: Settings = .settings(
    base: [:],
    configurations: [
        debugConfiguration,
    ]
)

let project = Project(
    name: "LocationsManager-Generated",
    organizationName: "Petrachkov-Experiments inc",
    packages: [.local(path: "LocationsManagerCore")],
    settings: settings,
    targets: [
        Target(
            name: "LocationsManager",
            platform: .iOS,
            product: .app,
            bundleId: "com.petrachkov.locationsmanagerhostapp",
            infoPlist: InfoPlist.dictionary([
                "CFBundleName": "$(APP_NAME)",
                "CFBundleVersion": "1",
                "CFBundleShortVersionString": "0.0.1",
                "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
                "CFBundleExecutable": "$(EXECUTABLE_NAME)",
                "CFBundlePackageType": "$(PRODUCT_BUNDLE_PACKAGE_TYPE)",
            ]),
//            infoPlist: .file(path: "LocationsManagerHostApp/LocationsManagerHostApp/Info.plist"),
            sources: ["LocationsManagerHostApp/**"],
            dependencies: [
                .package(product: "LocationsManagerCore")
            ],
            settings: .settings(
                configurations: [
                    debugConfiguration
//                    .debug(name: "Debug", xcconfig: .init("LocationsManagerHostApp/LocationsManagerHostApp/Configs/LocationsManager.xcconfig"))
                ],
                defaultSettings: .recommended(excluding: ["CODE_SIGN_IDENTITY"])
            )
        ),
        Target(
            name: "LocationsManager-Tests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.petrachkov.locationsmanagertests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "LocationsManager"),
            ]
        ),
    ],
    schemes: [debugScheme]
)
