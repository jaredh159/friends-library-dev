import GraphQL

@testable import App

extension OrderItem {
  static var mock: OrderItem {
    OrderItem(orderId: .init(), editionId: .init(), quantity: 42, unitPrice: 42)
  }

  static var empty: OrderItem {
    OrderItem(orderId: .init(), editionId: .init(), quantity: 0, unitPrice: 0)
  }

  static var random: OrderItem {
    OrderItem(
      orderId: .init(),
      editionId: .init(),
      quantity: Int.random,
      unitPrice: .init(rawValue: Int.random)
    )
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.lowercased),
      "orderId": .string(orderId.lowercased),
      "editionId": .string(editionId.lowercased),
      "quantity": .number(Number(quantity)),
      "unitPrice": .number(Number(unitPrice.rawValue)),
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
