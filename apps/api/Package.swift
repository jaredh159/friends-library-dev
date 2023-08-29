// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "graphql-api",
  platforms: [.macOS(.v12)],
  dependencies: [
    .github("vapor/vapor@4.67.4"),
    .github("vapor/fluent@4.4.0"),
    .github("vapor/fluent-postgres-driver@2.2.2"),
    .github("alexsteinerde/graphql-kit@2.3.0"),
    .github("m-barthelemy/vapor-queues-fluent-driver@1.2.0"),
    .github("jaredh159/swift-tagged@0.8.2"),
    .github("pointfreeco/swift-nonempty@0.3.0"),
    .github("kylehughes/RomanNumeralKit@1.0.0"),
    .github("JohnSundell/ShellOut@2.0.0"),
    .package(path: "../../libs-swift/duet"),
    .package(path: "../../libs-swift/x-http"),
    .package(path: "../../libs-swift/x-sendgrid"),
    .package(path: "../../libs-swift/x-stripe"),
    .package(path: "../../libs-swift/x-slack"),
    .package(path: "../../libs-swift/x-expect"),
  ],
  targets: [
    .target(
      name: "App",
      dependencies: [
        .product(name: "Fluent", package: "fluent"),
        .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
        .product(name: "Vapor", package: "vapor"),
        .product(name: "Tagged", package: "swift-tagged"),
        .product(name: "TaggedTime", package: "swift-tagged"),
        .product(name: "TaggedMoney", package: "swift-tagged"),
        .product(name: "NonEmpty", package: "swift-nonempty"),
        .product(name: "Duet", package: "duet"),
        .product(name: "DuetSQL", package: "duet"),
        .product(name: "XHttp", package: "x-http"),
        .product(name: "XSendGrid", package: "x-sendgrid"),
        .product(name: "XStripe", package: "x-stripe"),
        .product(name: "XSlack", package: "x-slack"),
        .product(name: "QueuesFluentDriver", package: "vapor-queues-fluent-driver"),
        .product(name: "GraphQLKit", package: "graphql-kit"),
        "RomanNumeralKit",
        "ShellOut",
      ],
      swiftSettings: [
        .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
      ]
    ),
    .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
    .testTarget(
      name: "AppTests",
      dependencies: [
        .target(name: "App"),
        .product(name: "Duet", package: "duet"),
        .product(name: "DuetSQL", package: "duet"),
        .product(name: "XSendGrid", package: "x-sendgrid"),
        .product(name: "XExpect", package: "x-expect"),
        .product(name: "XCTVapor", package: "vapor"),
      ]
    ),
  ]
)

// helpers

import Foundation

extension PackageDescription.Package.Dependency {
  static func github(_ commitish: String) -> Package.Dependency {
    let parts = commitish.split(separator: "@")
    return .package(
      url: "https://github.com/\(parts[0]).git",
      from: .init(stringLiteral: "\(parts[1])")
    )
  }
}
