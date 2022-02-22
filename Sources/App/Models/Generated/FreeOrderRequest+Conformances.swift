// auto-generated, do not edit
import Foundation
import Tagged

extension FreeOrderRequest: ApiModel {
  typealias Id = Tagged<FreeOrderRequest, UUID>
}

extension FreeOrderRequest: DuetModel {
  static let tableName = M6.tableName
  static var isSoftDeletable: Bool { false }
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
        return constraint.isSatisfiedBy(.id(self))
      case .name:
        return constraint.isSatisfiedBy(.string(name))
      case .email:
        return constraint.isSatisfiedBy(.string(email.rawValue))
      case .requestedBooks:
        return constraint.isSatisfiedBy(.string(requestedBooks))
      case .aboutRequester:
        return constraint.isSatisfiedBy(.string(aboutRequester))
      case .addressStreet:
        return constraint.isSatisfiedBy(.string(addressStreet))
      case .addressStreet2:
        return constraint.isSatisfiedBy(.string(addressStreet2))
      case .addressCity:
        return constraint.isSatisfiedBy(.string(addressCity))
      case .addressState:
        return constraint.isSatisfiedBy(.string(addressState))
      case .addressZip:
        return constraint.isSatisfiedBy(.string(addressZip))
      case .addressCountry:
        return constraint.isSatisfiedBy(.string(addressCountry))
      case .source:
        return constraint.isSatisfiedBy(.string(source))
      case .createdAt:
        return constraint.isSatisfiedBy(.date(createdAt))
      case .updatedAt:
        return constraint.isSatisfiedBy(.date(updatedAt))
    }
  }
}

extension FreeOrderRequest: Auditable {}
extension FreeOrderRequest: Touchable {}
