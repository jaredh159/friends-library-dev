import Foundation

enum Stripe {
  enum Api {
    struct PaymentIntent: Decodable {
      var id: String
      var clientSecret: String
    }

    struct Refund: Decodable {
      var id: String
    }
  }
}
