import DuetSQL
import Foundation
import PairQL
import Vapor

enum AdminRoute: PairRoute {
  case authed(UUID, AuthedAdminRoute)

  static let router = OneOf {
    Route(/Self.authed) {
      Headers {
        Field("Authorization") {
          Skip { "Bearer " }
          UUID.parser()
        }
      }
      AuthedAdminRoute.router
    }
  }
}

enum AuthedAdminRoute: PairRoute {
  case editDocument(Document.Id)
  case editFriend(Friend.Id)
  case getOrder(Order.Id)
  case listDocuments
  case listFriends
  case listOrders
  case listTokens
  case selectableDocuments

  static let router: AnyParserPrinter<URLRequestData, AuthedAdminRoute> = OneOf {
    Route(/Self.editDocument) {
      Operation(EditDocument.self)
      Body(.input(EditDocument.self))
    }
    Route(/Self.editFriend) {
      Operation(EditFriend.self)
      Body(.input(EditFriend.self))
    }
    Route(/Self.getOrder) {
      Operation(GetOrder.self)
      Body(.input(GetOrder.self))
    }
    Route(/Self.listFriends) {
      Operation(ListFriends.self)
    }
    Route(/Self.listOrders) {
      Operation(ListOrders.self)
    }
    Route(/Self.listDocuments) {
      Operation(ListDocuments.self)
    }
    Route(/Self.listTokens) {
      Operation(ListTokens.self)
    }
    Route(/Self.selectableDocuments) {
      Operation(SelectableDocuments.self)
    }
  }
  .eraseToAnyParserPrinter()
}

extension AdminRoute: RouteResponder {
  static func respond(to route: Self, in context: Context) async throws -> Response {
    switch route {
    case .authed(let token, let authedRoute):
      let token = try await Token.query().where(.value == token).first()
      let authed = AuthedContext(requestId: context.requestId, scopes: try await token.scopes())
      switch authedRoute {
      case .editDocument(let id):
        let output = try await EditDocument.resolve(with: id, in: authed)
        return try respond(with: output)
      case .editFriend(let id):
        let output = try await EditFriend.resolve(with: id, in: authed)
        return try respond(with: output)
      case .getOrder(let id):
        let output = try await GetOrder.resolve(with: id, in: authed)
        return try respond(with: output)
      case .listDocuments:
        let output = try await ListDocuments.resolve(in: authed)
        return try respond(with: output)
      case .listFriends:
        let output = try await ListFriends.resolve(in: authed)
        return try respond(with: output)
      case .listOrders:
        let output = try await ListOrders.resolve(in: authed)
        return try respond(with: output)
      case .listTokens:
        let output = try await ListTokens.resolve(in: authed)
        return try respond(with: output)
      case .selectableDocuments:
        let output = try await SelectableDocuments.resolve(in: authed)
        return try respond(with: output)
      }
    }
  }
}
