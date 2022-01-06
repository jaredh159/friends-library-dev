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

extension FreeOrderRequest: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool {
    switch constraint.column {
      case "id":
        return .id(self) == constraint.value
      case "name":
        return .string(name) == constraint.value
      case "email":
        return .string(email.rawValue) == constraint.value
      case "requested_books":
        return .string(requestedBooks) == constraint.value
      case "about_requester":
        return .string(aboutRequester) == constraint.value
      case "address_street":
        return .string(addressStreet) == constraint.value
      case "address_street2":
        return .string(addressStreet2) == constraint.value
      case "address_city":
        return .string(addressCity) == constraint.value
      case "address_state":
        return .string(addressState) == constraint.value
      case "address_zip":
        return .string(addressZip) == constraint.value
      case "address_country":
        return .string(addressCountry) == constraint.value
      case "source":
        return .string(source) == constraint.value
      case "created_at":
        return .date(createdAt) == constraint.value
      case "updated_at":
        return .date(updatedAt) == constraint.value
      default:
        return false
    }
  }
}

extension FreeOrderRequest: Auditable {}
extension FreeOrderRequest: Touchable {}
