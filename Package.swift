// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftCodeGenerator",
  dependencies: [
    .package(url: "https://github.com/johnsundell/files.git", from: "1.0.0"),
    .package(url: "https://github.com/Carthage/Commandant.git", from: "0.0.0"),
    .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0"),
    .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0")
  ],
  targets: [
    .target(
      name: "SwiftCodeGenerator",
      dependencies: ["SwiftCodeGeneratorCore"]
    ),
    .target(
      name: "SwiftCodeGeneratorCore",
      dependencies: ["Files", "Commandant", "SwiftyJSON", "Rainbow"]
    ),
    .testTarget(
        name: "SwiftCodeGeneratorTests",
        dependencies: ["SwiftCodeGeneratorCore", "Files", "Commandant", "SwiftyJSON", "Rainbow"]
    )
  ]
)
