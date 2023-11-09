import PairQL

extension CodegenRoute.Order: CodegenRouteHandler {
  static var sharedTypes: [(String, Any.Type)] {
    [("ShippingAddress", ShippingAddress.self)]
  }

  static var pairqlPairs: [any Pair.Type] {
    [
      CreateOrder.self,
      GetPrintJobExploratoryMetadata.self,
    ]
  }
}
