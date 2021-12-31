// auto-generated, do not edit
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
}
