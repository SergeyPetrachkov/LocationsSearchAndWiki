import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .local(path: "LocationsManagerCore/")
    ],
    platforms: [.iOS]
)
