import PairQL
import Rainbow
import Vapor
import VaporRouting

enum PairQLRoute: RouteHandler, RouteResponder, Equatable {
  case dev(DevRoute)
  case admin(AdminRoute)
  case order(OrderRoute)
  case evans(EvansRoute)
  case evansBuild(EvansBuildRoute)
  case nextEvansBuild(NextEvansBuildRoute)

  static func respond(to route: Self, in context: Context) async throws -> Response {
    switch route {
    case .dev(let devRoute):
      return try await DevRoute.respond(to: devRoute, in: context)
    case .admin(let adminRoute):
      return try await AdminRoute.respond(to: adminRoute, in: context)
    case .order(let orderRoute):
      return try await OrderRoute.respond(to: orderRoute, in: context)
    case .evans(let evansRoute):
      return try await EvansRoute.respond(to: evansRoute, in: context)
    case .evansBuild(let evansBuildRoute):
      return try await EvansBuildRoute.respond(to: evansBuildRoute, in: context)
    case .nextEvansBuild(let nextEvansBuildRoute):
      return try await NextEvansBuildRoute.respond(to: nextEvansBuildRoute, in: context)
    }
  }

  static let router = OneOf {
    Route(.case(PairQLRoute.dev)) {
      Method.post
      Path { "dev" }
      DevRoute.router
    }
    Route(.case(PairQLRoute.admin)) {
      Method.post
      Path { "admin" }
      AdminRoute.router
    }
    Route(.case(PairQLRoute.order)) {
      Method.post
      Path { "order" }
      OrderRoute.router
    }
    Route(.case(PairQLRoute.evans)) {
      Method.post
      Path { "evans" }
      EvansRoute.router
    }
    Route(.case(PairQLRoute.evansBuild)) {
      Method.post
      Path { "evans-build" }
      EvansBuildRoute.router
    }
    Route(.case(PairQLRoute.nextEvansBuild)) {
      Method.post
      Path { "next-evans-build" }
      NextEvansBuildRoute.router
    }
  }

  static func handler(_ request: Request) async throws -> Response {
    guard var requestData = URLRequestData(request: request),
          requestData.path.removeFirst() == "pairql" else {
      throw Abort(.badRequest)
    }

    let context = Context(requestId: request.id)
    do {
      let route = try PairQLRoute.router.parse(requestData)
      logOperation(route, request)
      return try await PairQLRoute.respond(to: route, in: context)
    } catch {
      if "\(type(of: error))" == "ParsingError" {
        if Env.mode == .dev { print("PairQL routing \(error)") }
        return .init(PqlError(
          id: "0f5a25c9",
          requestId: context.requestId,
          type: .notFound,
          detail: Env.mode == .dev ? "PairQL routing \(error)" : "PairQL route not found"
        ))
      } else if let pqlError = error as? PqlError {
        return .init(pqlError)
      } else if let convertible = error as? PqlErrorConvertible {
        return .init(convertible.pqlError(in: context))
      } else {
        print(type(of: error), error)
        throw error
      }
    }
  }
}

// helpers

private func logOperation(_ route: PairQLRoute, _ request: Request) {
  let operation = request.parameters.get("operation") ?? ""
  switch route {
  case .dev:
    Current.logger
      .notice("PairQL request: \("Dev".magenta) \(operation.yellow)")
  case .admin:
    Current.logger
      .notice("PairQL request: \("Admin".cyan) \(operation.yellow)")
  case .order:
    Current.logger
      .notice("PairQL request: \("Order".red) \(operation.yellow)")
  case .evans:
    Current.logger
      .notice("PairQL request: \("Evans".lightBlue) \(operation.yellow)")
  case .evansBuild:
    Current.logger
      .notice("PairQL request: \("EvansBuild".green) \(operation.yellow)")
  case .nextEvansBuild:
    Current.logger
      .notice("PairQL request: \("NextEvansBuild".green) \(operation.yellow)")
  }
}
