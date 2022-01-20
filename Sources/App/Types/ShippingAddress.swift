import Graphiti

struct ShippingAddress: Codable {
  var name: String
  var street: String
  var street2: String?
  var city: String
  var state: String
  var zip: String
  var country: String
}

// extensions

extension AppSchema {
  static var ShippingAddressType: AppType<ShippingAddress> {
    Type(ShippingAddress.self) {
      Field("name", at: \.name)
      Field("street", at: \.street)
      Field("street2", at: \.street2)
      Field("city", at: \.city)
      Field("state", at: \.state)
      Field("zip", at: \.zip)
      Field("country", at: \.country)
    }
  }
}
