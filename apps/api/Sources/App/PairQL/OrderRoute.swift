import DuetSQL
import Foundation
import PairQL
import Vapor

enum OrderRoute: PairRoute {
  case getPrintJobExploratoryMetadata(GetPrintJobExploratoryMetadata.Input)
  case createOrder(UUID, CreateOrder.Input)

  static let router = OneOf {
    Route(/Self.getPrintJobExploratoryMetadata) {
      Operation(GetPrintJobExploratoryMetadata.self)
      Body(.input(GetPrintJobExploratoryMetadata.self))
    }
    Route(/Self.createOrder) {
      Headers {
        Field("Authorization") {
          Skip { "Bearer " }
          UUID.parser()
        }
      }
      Operation(CreateOrder.self)
      Body(.input(CreateOrder.self))
    }
  }
}

extension OrderRoute: RouteResponder {
  static func respond(to route: Self, in context: Context) async throws -> Response {
    switch route {
    case .getPrintJobExploratoryMetadata(let input):
      let output = try await GetPrintJobExploratoryMetadata.resolve(with: input, in: context)
      return try respond(with: output)
    case .createOrder(let token, let input):
      try await CreateOrder.authenticate(with: .init(token))
      let output = try await CreateOrder.resolve(with: input, in: context)
      return try respond(with: output)
    }
  }
}
