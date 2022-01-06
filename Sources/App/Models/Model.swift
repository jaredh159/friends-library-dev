import Foundation
import NIO
import Tagged

protocol AppModel: Codable, Equatable {}

enum Children<C: AppModel>: Codable {
  case notLoaded
  case loaded([C])
}

enum Parent<M: AppModel> {
  case notLoaded
  case loaded(M)
}

enum OptionalParent<M: AppModel> {
  case notLoaded
  case loaded(M?)
}

enum OptionalChild<M: AppModel> {
  case notLoaded
  case loaded(M?)
}

protocol UUIDStringable {
  var uuidString: String { get }
}

protocol UUIDIdentifiable {
  var uuidId: UUID { get }
}

protocol DuetModel: Codable, UUIDIdentifiable, Equatable {
  associatedtype IdValue: RandomEmptyInitializing, UUIDStringable, Hashable
  var id: IdValue { get set }
  associatedtype ColumnName: CodingKey
  static func columnName(_ column: ColumnName) -> String
  static var tableName: String { get }
  var insertValues: [String: Postgres.Data] { get }
}

extension DuetModel {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }

  var updateValues: [String: Postgres.Data] {
    var insert = insertValues
    insert["id"] = nil
    insert["createdAt"] = nil
    return insert
  }
}

extension DuetModel where Self: Touchable {
  var updateValues: [String: Postgres.Data] {
    var insert = insertValues
    insert["id"] = nil
    insert["createdAt"] = nil
    insert["updatedAt"] = .date(Current.date())
    return insert
  }
}

extension DuetModel where ColumnName: RawRepresentable, ColumnName.RawValue == String {
  static func columnName(_ column: ColumnName) -> String {
    column.rawValue.snakeCased
  }

  static subscript(_ column: ColumnName) -> String {
    columnName(column)
  }
}

extension DuetModel where IdValue: RawRepresentable, IdValue.RawValue == UUID {
  var uuidId: UUID { id.rawValue }
}

extension Array where Element: DuetModel {
  func firstOrThrowNotFound() throws -> Element {
    guard let first = self.first else { throw DbError.notFound }
    return first
  }
}

protocol SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool
}

protocol RandomEmptyInitializing {
  init()
}

extension Tagged: RandomEmptyInitializing where RawValue == UUID {
  init() {
    self.init(rawValue: UUID())
  }
}

extension UUID: UUIDStringable {}

extension Tagged: UUIDStringable where RawValue == UUID {
  var uuidString: String { self.rawValue.uuidString }
}

protocol Auditable: DuetModel {
  var createdAt: Date { get set }
}

protocol Touchable: DuetModel {
  var updatedAt: Date { get set }
}

protocol SoftDeletable: DuetModel {
  var deletedAt: Date? { get set }
}
