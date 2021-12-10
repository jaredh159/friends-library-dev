import Foundation
import Tagged

protocol AltModel: Codable {
  associatedtype ColumnName: CodingKey
  associatedtype IdValue: EmptyInitializing
  var id: IdValue { get set }
  static func columnName(_ column: ColumnName) -> String
  static subscript(_ column: ColumnName) -> String { get }
  static var tableName: String { get }
}

extension AltModel where ColumnName: RawRepresentable, ColumnName.RawValue == String {
  static func columnName(_ column: ColumnName) -> String {
    column.rawValue.snakeCased
  }

  static subscript(_ column: ColumnName) -> String {
    columnName(column)
  }
}

enum Alt {

  enum Children<C> {
    case notLoaded
    case loaded([C])
  }

  enum Parent<P: AltModel> {
    case notLoaded
    case loaded(P)
  }

  final class Token: AltModel {
    typealias Id = Tagged<(Token, id: ()), UUID>
    typealias Value = Tagged<(Token, value: ()), UUID>

    static let tableName = "tokens"

    var id: Id
    var value: Value
    var description: String
    var createdAt = Current.date()

    var scopes = Children<TokenScope>.notLoaded

    init(id: Id = .init(), value: Value = .init(), description: String) {
      self.id = id
      self.value = value
      self.description = description
    }
  }

  final class TokenScope: AltModel {
    typealias Id = Tagged<TokenScope, UUID>

    static let tableName = "token_scopes"

    var id: Id
    var scope: Scope
    var tokenId: Token.Id
    var createdAt = Current.date()

    var token = Parent<Token>.notLoaded

    init(id: Id = .init(), tokenId: Token.Id, scope: Scope) {
      self.id = id
      self.scope = scope
      self.tokenId = tokenId
    }
  }
}

extension Alt.Token: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case value
    case description
    case createdAt
  }
}

extension Alt.TokenScope: Codable {
  typealias ColumnName = CodingKeys

  enum CodingKeys: String, CodingKey {
    case id
    case scope
    case tokenId
    case createdAt
  }
}
