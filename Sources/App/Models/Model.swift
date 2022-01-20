import Foundation
import NIO
import Tagged
import Vapor

enum PreloadedEntityType {
  case friend(Friend.Type)
  case friendQuote(FriendQuote.Type)
  case friendResidence(FriendResidence.Type)
  case friendResidenceDuration(FriendResidenceDuration.Type)
  case document(Document.Type)
  case documentTag(DocumentTag.Type)
  case relatedDocument(RelatedDocument.Type)
  case edition(Edition.Type)
  case editionImpression(EditionImpression.Type)
  case editionChapter(EditionChapter.Type)
  case audio(Audio.Type)
  case audioPart(AudioPart.Type)
}

protocol ApiModel: Codable, Equatable {
  static var preloadedEntityType: PreloadedEntityType? { get }
}

extension ApiModel {
  static var preloadedEntityType: PreloadedEntityType? { nil }
  static var isPreloaded: Bool { preloadedEntityType != nil }
}

enum RelationError: Error {
  case notLoaded
}

enum Children<C: ApiModel>: Codable {
  case notLoaded
  case loaded([C])

  var models: [C] {
    get throws {
      guard case .loaded(let loaded) = self else {
        throw RelationError.notLoaded
      }
      return loaded
    }
  }

  func require(file: StaticString = #file, line: UInt = #line) -> [C] {
    guard let models = try? models else {
      invariant("Required children [\(C.self)] not loaded at \(file):\(line)")
    }
    return models
  }
}

enum Parent<P: ApiModel> {
  case notLoaded
  case loaded(P)

  var model: P {
    get throws {
      guard case .loaded(let loaded) = self else {
        throw RelationError.notLoaded
      }
      return loaded
    }
  }

  func require(file: StaticString = #file, line: UInt = #line) -> P {
    guard let model = try? model else {
      invariant("Required parent \(P.self) not loaded at \(file):\(line)")
    }
    return model
  }
}

enum OptionalParent<P: ApiModel> {
  case notLoaded
  case loaded(P?)

  var model: P? {
    get throws {
      guard case .loaded(let loaded) = self else {
        throw RelationError.notLoaded
      }
      return loaded
    }
  }

  func require(file: StaticString = #file, line: UInt = #line) -> P? {
    guard case .loaded(let model) = self else {
      invariant("Required optional parent \(P.self) not loaded at \(file):\(line)")
    }
    return model
  }
}

enum OptionalChild<C: ApiModel> {
  case notLoaded
  case loaded(C?)

  var model: C? {
    get throws {
      guard case .loaded(let loaded) = self else {
        throw RelationError.notLoaded
      }
      return loaded
    }
  }

  func require(file: StaticString = #file, line: UInt = #line) -> C? {
    guard case .loaded(let model) = self else {
      invariant("Required optional child \(C.self) not loaded at \(file):\(line)")
    }
    return model
  }
}

protocol UUIDStringable {
  var uuidString: String { get }
}

protocol UUIDIdentifiable {
  var uuidId: UUID { get }
}

protocol DuetModel: UUIDIdentifiable, SQLInspectable, ApiModel {
  associatedtype IdValue: RandomEmptyInitializing, UUIDStringable, Hashable
  var id: IdValue { get set }
  associatedtype ColumnName: CodingKey, Hashable, CaseIterable
  static func columnName(_ column: ColumnName) -> String
  static var tableName: String { get }
  var insertValues: [ColumnName: Postgres.Data] { get }
}

extension DuetModel {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }

  static func column(_ name: String) throws -> ColumnName {
    for column in ColumnName.allCases {
      if Self.columnName(column) == name {
        return column
      }
    }
    throw DuetError.missingExpectedColumn(name)
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
    guard let first = first else { throw DbError.notFound }
    return first
  }
}

protocol SQLInspectable {
  associatedtype Model: DuetModel
  func satisfies(constraint: SQL.WhereConstraint<Model>) -> Bool
}

extension SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint<Model>?) -> Bool {
    if let constraint = constraint {
      return satisfies(constraint: constraint)
    }
    return true
  }
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
  var uuidString: String { rawValue.uuidString }
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

enum DuetError: Error {
  case missingExpectedColumn(String)
}

extension DuetModel {
  func introspectValue(at column: String) throws -> Any {
    let mirror = Mirror(reflecting: self)
    for child in mirror.children {
      if child.label == column {
        return child.value
      }
    }
    return DuetError.missingExpectedColumn(column)
  }
}

extension Array where Element: DuetModel {
  mutating func order<M: DuetModel>(by order: SQL.Order<M>) throws {
    try sort { a, b in
      let propA = try a.introspectValue(at: order.column.stringValue)
      let propB = try b.introspectValue(at: order.column.stringValue)
      switch (propA, propB) {
        case (let dateA, let dateB) as (Date, Date):
          return order.direction == .asc ? dateA < dateB : dateA > dateB
        default:
          throw Abort(
            .notImplemented,
            reason: "[DuetModel].order(by:) not implemented for \(type(of: propA))"
          )
      }
    }
  }
}
