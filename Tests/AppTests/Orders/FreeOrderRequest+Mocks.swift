@testable import App

extension FreeOrderRequest {
  static var mock: FreeOrderRequest {
    FreeOrderRequest(
      name: "Bob McMock",
      email: .init(rawValue: "you@example.com"),
      requestedBooks: "all of them",
      aboutRequester: "not a freebie hunter",
      addressStreet: "123 Magnolia Lane",
      addressStreet2: nil,
      addressCity: "Detroit",
      addressState: "MI",
      addressZip: "48302",
      addressCountry: "US",
      source: "/rad-site"
    )
  }
}
