import Fluent
import Tagged
import Vapor

final class FreeOrderRequest: Codable {
  var id: Id
  var name: String
  var email: EmailAddress
  var requestedBooks: String
  var aboutRequester: String
  var addressStreet: String
  var addressStreet2: String?
  var addressCity: String
  var addressState: String
  var addressZip: String
  var addressCountry: String
  var source: String
  var createdAt = Current.date()
  var updatedAt = Current.date()

  init(
    id: Id = .init(),
    name: String,
    email: EmailAddress,
    requestedBooks: String,
    aboutRequester: String,
    addressStreet: String,
    addressStreet2: String?,
    addressCity: String,
    addressState: String,
    addressZip: String,
    addressCountry: String,
    source: String
  ) {
    self.id = id
    self.name = name
    self.email = email
    self.requestedBooks = requestedBooks
    self.aboutRequester = aboutRequester
    self.addressStreet = addressStreet
    self.addressStreet2 = addressStreet2
    self.addressCity = addressCity
    self.addressState = addressState
    self.addressZip = addressZip
    self.addressCountry = addressCountry
    self.source = source
  }
}
