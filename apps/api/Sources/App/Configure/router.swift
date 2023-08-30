import GraphQLKit
import Vapor

public extension Configure {
  static func router(_ app: Application) throws {
    LegacyRest.addRoutes(app)

    app.get(
      "download", "**",
      use: downloadFileRouteHandler(req:)
    )

    app.get(
      "codegen", "**",
      use: CodegenRoute.handler(_:)
    )

    app.on(
      .POST,
      "pairql", ":domain", ":operation",
      body: .collect(maxSize: "512kb"),
      use: PairQLRoute.handler(_:)
    )

    // legacy
    app
      .grouped(UserAuthenticator())
      .register(
        graphQLSchema: appSchema,
        withResolver: Resolver(),
        at: "graphql",
        postBodyStreamStrategy: .collect(maxSize: "64kb")
      )
  }
}
