// auto-generated, do not edit
import Foundation
import Tagged

extension FreeOrderRequest: ApiModel {
  typealias Id = Tagged<FreeOrderRequest, UUID>
}

extension FreeOrderRequest: DuetModel {
  static let tableName = M6.tableName
}

extension FreeOrderRequest {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey, CaseIterable {
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

extension FreeOrderRequest {
  var insertValues: [ColumnName: Postgres.Data] {
    [
      .id: .id(self),
      .name: .string(name),
      .email: .string(email.rawValue),
      .requestedBooks: .string(requestedBooks),
      .aboutRequester: .string(aboutRequester),
      .addressStreet: .string(addressStreet),
      .addressStreet2: .string(addressStreet2),
      .addressCity: .string(addressCity),
      .addressState: .string(addressState),
      .addressZip: .string(addressZip),
      .addressCountry: .string(addressCountry),
      .source: .string(source),
      .createdAt: .currentTimestamp,
      .updatedAt: .currentTimestamp,
    ]
  }
}

extension FreeOrderRequest: SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<FreeOrderRequest>) -> Bool {
    switch constraint.column {
      case .id:
        return .id(self) == constraint.value
      case .name:
        return .string(name) == constraint.value
      case .email:
        return .string(email.rawValue) == constraint.value
      case .requestedBooks:
        return .string(requestedBooks) == constraint.value
      case .aboutRequester:
        return .string(aboutRequester) == constraint.value
      case .addressStreet:
        return .string(addressStreet) == constraint.value
      case .addressStreet2:
        return .string(addressStreet2) == constraint.value
      case .addressCity:
        return .string(addressCity) == constraint.value
      case .addressState:
        return .string(addressState) == constraint.value
      case .addressZip:
        return .string(addressZip) == constraint.value
      case .addressCountry:
        return .string(addressCountry) == constraint.value
      case .source:
        return .string(source) == constraint.value
      case .createdAt:
        return .date(createdAt) == constraint.value
      case .updatedAt:
        return .date(updatedAt) == constraint.value
    }
  }
}

extension FreeOrderRequest: Auditable {}
extension FreeOrderRequest: Touchable {}
