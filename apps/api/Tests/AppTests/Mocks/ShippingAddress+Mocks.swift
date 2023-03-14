@testable import App
import GraphQL

extension ShippingAddress {
  static let mock: Self = .init(
    name: "Steve Jobs",
    street: "One Apple Park Way",
    street2: nil,
    city: "Cupertino",
    state: "CA",
    zip: "95014",
    country: "US"
  )

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "name": .string(name),
      "street": .string(street),
      "street2": street2 == nil ? .null : .string(street2!),
      "city": .string(city),
      "state": .string(state),
      "zip": .string(self.zip),
      "country": .string(country),
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
