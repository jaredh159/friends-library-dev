// auto-generated, do not edit
import Foundation
import Tagged

extension FreeOrderRequest: AppModel {
  typealias Id = Tagged<FreeOrderRequest, UUID>
}

extension FreeOrderRequest: DuetModel {
  static let tableName = M6.tableName
}

extension FreeOrderRequest {
  var insertValues: [String: Postgres.Data] {
    [
      Self[.id]: .id(self),
      Self[.name]: .string(name),
      Self[.email]: .string(email.rawValue),
      Self[.requestedBooks]: .string(requestedBooks),
      Self[.aboutRequester]: .string(aboutRequester),
      Self[.addressStreet]: .string(addressStreet),
      Self[.addressStreet2]: .string(addressStreet2),
      Self[.addressCity]: .string(addressCity),
      Self[.addressState]: .string(addressState),
      Self[.addressZip]: .string(addressZip),
      Self[.addressCountry]: .string(addressCountry),
      Self[.source]: .string(source),
      Self[.createdAt]: .currentTimestamp,
      Self[.updatedAt]: .currentTimestamp,
    ]
  }
}

extension FreeOrderRequest {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case email
    case requestedBooks
    case aboutRequester
    case addressStreet
    case addressStreet2
    case addressCity
    case addressState
    case addressZip
    case addressCountry
    case source
    case createdAt
    case updatedAt
  }
}

extension FreeOrderRequest: Auditable {}
extension FreeOrderRequest: Touchable {}
