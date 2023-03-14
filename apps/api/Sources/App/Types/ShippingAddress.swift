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
  struct ShippingAddressInput: Codable {
    var name: String
    var street: String
    var street2: String?
    var city: String
    var state: String
    var zip: String
    var country: String

    var shippingAddress: ShippingAddress {
      ShippingAddress(
        name: name,
        street: street,
        street2: street2,
        city: city,
        state: state,
        zip: zip,
        country: country
      )
    }
  }

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

  static var ShippingAddressInputType: AppInput<ShippingAddressInput> {
    Input(ShippingAddressInput.self) {
      InputField("name", at: \.name)
      InputField("street", at: \.street)
      InputField("street2", at: \.street2)
      InputField("city", at: \.city)
      InputField("state", at: \.state)
      InputField("zip", at: \.zip)
      InputField("country", at: \.country)
    }
  }
}
