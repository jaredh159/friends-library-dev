import DuetSQL
import Foundation
import PairQL
import TaggedMoney
import Vapor

enum OrderRoute: PairRoute {
  case brickOrder(BrickOrder.Input)
  case createOrder(UUID, CreateOrder.Input)
  case initOrder(Cents<Int>)
  case logJsError(LogJsError.Input)
  case getPrintJobExploratoryMetadata(GetPrintJobExploratoryMetadata.Input)
  case sendOrderConfirmationEmail(Order.Id)

  static let router = OneOf {
    Route(/Self.brickOrder) {
      Operation(BrickOrder.self)
      Body(.input(BrickOrder.self))
    }
    Route(/Self.getPrintJobExploratoryMetadata) {
      Operation(GetPrintJobExploratoryMetadata.self)
      Body(.input(GetPrintJobExploratoryMetadata.self))
    }
    Route(/Self.logJsError) {
      Operation(LogJsError.self)
      Body(.input(LogJsError.self))
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
    Route(/Self.initOrder) {
      Operation(InitOrder.self)
      Body(.input(InitOrder.self))
    }
    Route(/Self.sendOrderConfirmationEmail) {
      Operation(SendOrderConfirmationEmail.self)
      Body(.input(SendOrderConfirmationEmail.self))
    }
  }
}

extension OrderRoute: RouteResponder {
  static func respond(to route: Self, in context: Context) async throws -> Response {
    switch route {
    case .brickOrder(let input):
      let output = try await BrickOrder.resolve(with: input, in: context)
      return try respond(with: output)
    case .getPrintJobExploratoryMetadata(let input):
      let output = try await GetPrintJobExploratoryMetadata.resolve(with: input, in: context)
      return try respond(with: output)
    case .createOrder(let token, let input):
      try await CreateOrder.authenticate(with: .init(token))
      let output = try await CreateOrder.resolve(with: input, in: context)
      return try respond(with: output)
    case .logJsError(let input):
      let output = try await LogJsError.resolve(with: input, in: context)
      return try respond(with: output)
    case .initOrder(let input):
      let output = try await InitOrder.resolve(with: input, in: context)
      return try respond(with: output)
    case .sendOrderConfirmationEmail(let input):
      let output = try await SendOrderConfirmationEmail.resolve(with: input, in: context)
      return try respond(with: output)
    }
  }
}
