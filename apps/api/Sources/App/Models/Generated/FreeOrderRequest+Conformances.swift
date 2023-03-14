// auto-generated, do not edit
import DuetSQL
import Tagged

extension FreeOrderRequest: ApiModel {
  typealias Id = Tagged<FreeOrderRequest, UUID>
}

extension FreeOrderRequest: Model {
  static let tableName = M6.tableName

  func postgresData(for column: ColumnName) -> Postgres.Data {
    switch column {
      case .id:
        return .id(self)
      case .name:
        return .string(name)
      case .email:
        return .string(email.rawValue)
      case .requestedBooks:
        return .string(requestedBooks)
      case .aboutRequester:
        return .string(aboutRequester)
      case .addressStreet:
        return .string(addressStreet)
      case .addressStreet2:
        return .string(addressStreet2)
      case .addressCity:
        return .string(addressCity)
      case .addressState:
        return .string(addressState)
      case .addressZip:
        return .string(addressZip)
      case .addressCountry:
        return .string(addressCountry)
      case .source:
        return .string(source)
      case .createdAt:
        return .date(createdAt)
      case .updatedAt:
        return .date(updatedAt)
    }
  }
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
