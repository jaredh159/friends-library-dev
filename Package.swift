// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "graphql-api",
  platforms: [
    .macOS(.v12),
  ],
  dependencies: [
    .package(
      url: "https://github.com/vapor/vapor.git",
      from: "4.55.3"
    ),
    .package(
      url: "https://github.com/vapor/fluent.git",
      from: "4.4.0"
    ),
    .package(
      url: "https://github.com/vapor/fluent-postgres-driver.git",
      from: "2.2.2"
    ),
    .package(
      name: "GraphQLKit",
      url: "https://github.com/alexsteinerde/graphql-kit.git",
      from: "2.3.0"
    ),
    .package(
      name: "QueuesFluentDriver",
      url: "https://github.com/m-barthelemy/vapor-queues-fluent-driver.git",
      from: "1.2.0"
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-tagged",
      from: "0.6.0"
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-nonempty.git",
      from: "0.3.0"
    ),
    .package(
      url: "https://github.com/kylehughes/RomanNumeralKit.git",
      from: "1.0.0"
    ),
    .package(
      url: "https://github.com/JohnSundell/ShellOut.git",
      from: "2.0.0"
    ),
    .package(
      url: "https://github.com/gertrude-app/duet.git",
      from: "1.0.0"
    ),
    .package(
      url: "https://github.com/jaredh159/x-kit.git",
      from: "1.0.2"
    ),
    .package(
      url: "https://github.com/jaredh159/x-http.git",
      from: "1.0.0"
    ),
    .package(
      url: "https://github.com/jaredh159/x-sendgrid.git",
      from: "1.0.1"
    ),
    .package(
      url: "https://github.com/jaredh159/x-stripe.git",
      from: "1.0.1"
    ),
    .package(
      url: "https://github.com/jaredh159/x-slack.git",
      from: "1.0.2"
    ),
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
        .product(name: "XVapor", package: "x-kit"),
        .product(name: "XHttp", package: "x-http"),
        .product(name: "XSendGrid", package: "x-sendgrid"),
        .product(name: "XStripe", package: "x-stripe"),
        .product(name: "XSlack", package: "x-slack"),
        "RomanNumeralKit",
        "GraphQLKit",
        "QueuesFluentDriver",
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
        .product(name: "DuetMock", package: "duet"),
        .product(name: "DuetSQL", package: "duet"),
        .product(name: "XGraphQLTest", package: "x-kit"),
        .product(name: "XSendGrid", package: "x-sendgrid"),
        .product(name: "XCTVapor", package: "vapor"),
      ]
    ),
  ]
)
