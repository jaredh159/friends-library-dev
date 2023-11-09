import Foundation
import PairQL
import TaggedMoney

struct GetFreeOrderRequest: Pair {
  static var auth: Scope = .queryOrders

  typealias Input = FreeOrderRequest.Id

  struct Output: PairOutput {
    let email: EmailAddress
    let address: ShippingAddress
  }
}

// resolver

extension GetFreeOrderRequest: PairQL.Resolver {
  static func resolve(with id: Input, in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let request = try await FreeOrderRequest.find(id)
    return .init(email: request.email, address: request.address)
  }
}
