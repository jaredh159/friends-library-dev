import Vapor

enum LegacyRest {

  static func addRoutes(_ app: Application) {
    /*
     "/app-editions/v1/en",
     "/app-editions/latest/en",
     "/app-editions/v1/es",
     "/app-editions/latest/es",
     */
    app.get("app-editions", "*", ":lang") { req -> Response in
      guard let lang = Lang(rawValue: req.parameters.get("lang") ?? "") else {
        await slackError("Unexpected legacy REST request: `GET \(req.url)`")
        throw Abort(.notFound)
      }
      return try await appEditions(lang: lang)
    }

    /*
      "/app-audios/?lang=en|es",
     */
    app.get("app-audios") { req -> Response in
      struct LangQuery: Content { let lang: Lang }
      guard let query = try? req.query.decode(LangQuery.self) else {
        await slackError("Unexpected legacy REST request: `GET \(req.url)`")
        throw Abort(.notFound)
      }
      return try await appAudios(lang: query.lang)
    }

    /*
      "/app-audios/v1/en",
      "/app-audios/latest/en",
      "/app-audios/v1/es",
      "/app-audios/latest/es",
     */
    app.get("app-audios", "*", ":lang") { req -> Response in
      guard let lang = Lang(rawValue: req.parameters.get("lang") ?? "") else {
        await slackError("Unexpected legacy REST request: `GET \(req.url)`")
        throw Abort(.notFound)
      }
      return try await appAudios(lang: lang)
    }
  }
}
