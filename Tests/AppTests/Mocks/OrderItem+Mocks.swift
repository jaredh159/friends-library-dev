// auto-generated, do not edit
import GraphQL

@testable import App

extension OrderItem {
  static var mock: OrderItem {
    OrderItem(
      orderId: .init(),
      documentId: .init(),
      editionType: .updated,
      title: "@mock title",
      quantity: 42,
      unitPrice: 42
    )
  }

  static var empty: OrderItem {
    OrderItem(
      orderId: .init(),
      documentId: .init(),
      editionType: .updated,
      title: "",
      quantity: 0,
      unitPrice: 0
    )
  }

  static var random: OrderItem {
    OrderItem(
      orderId: .init(),
      documentId: .init(),
      editionType: EditionType.allCases.shuffled().first!,
      title: "@random".random,
      quantity: Int.random,
      unitPrice: .init(rawValue: Int.random)
    )
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.rawValue.uuidString),
      "orderId": .string(orderId.rawValue.uuidString),
      "documentId": .string(documentId.rawValue.uuidString),
      "editionType": .string(editionType.rawValue),
      "title": .string(title),
      "quantity": .number(Number(quantity)),
      "unitPrice": .number(Number(unitPrice.rawValue)),
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
