import Graphiti

struct ShippingAddress: Codable {
  var name: String
  var street: String
  var street2: String?
  var city: String
  var state: String
  var zip: String
  var country: String

  init(
    name: String,
    street: String,
    street2: String? = nil,
    city: String,
    state: String,
    zip: String,
    country: String
  ) {
    self.name = name
    self.street = street
    self.street2 = street2
    self.city = city
    self.state = state
    self.zip = zip
    self.country = country

    if country == "US" {
      self.state = abbreviateState(state)
    }
  }
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

func abbreviateState(_ input: String) -> String {
  let states = [
    "alabama": "AL",
    "alaska": "AK",
    "arizona": "AZ",
    "arkansas": "AR",
    "california": "CA",
    "colorado": "CO",
    "connecticut": "CT",
    "delaware": "DE",
    "florida": "FL",
    "georgia": "GA",
    "hawaii": "HI",
    "idaho": "ID",
    "illinois": "IL",
    "indiana": "IN",
    "iowa": "IA",
    "kansas": "KS",
    "kentucky": "KY",
    "louisiana": "LA",
    "maine": "ME",
    "maryland": "MD",
    "massachusetts": "MA",
    "michigan": "MI",
    "minnesota": "MN",
    "mississippi": "MS",
    "missouri": "MO",
    "montana": "MT",
    "nebraska": "NE",
    "nevada": "NV",
    "new hampshire": "NH",
    "new jersey": "NJ",
    "new mexico": "NM",
    "new york": "NY",
    "north carolina": "NC",
    "north dakota": "ND",
    "ohio": "OH",
    "oklahoma": "OK",
    "oregon": "OR",
    "pennsylvania": "PA",
    "rhode island": "RI",
    "south carolina": "SC",
    "south dakota": "SD",
    "tennessee": "TN",
    "texas": "TX",
    "utah": "UT",
    "vermont": "VT",
    "virginia": "VA",
    "washington": "WA",
    "west virginia": "WV",
    "wisconsin": "WI",
    "wyoming": "WY",
  ]

  let lowercaseInput = input
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .lowercased()

  return states[lowercaseInput] ?? input
}
