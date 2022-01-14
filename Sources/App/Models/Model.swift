import Foundation
import NIO
import Tagged

protocol AppModel: Codable, Equatable {}

struct DuetQuery<Model: DuetModel> {
  let db: SQLQuerying & SQLMutating
  let constraints: [SQL.WhereConstraint]
  let limit: Int?
  let order: SQL.Order?

  func byId(_ id: UUID) -> DuetQuery<Model> {
    .init(db: db, constraints: constraints + ["id" == .uuid(id)], limit: limit, order: order)
  }

  func byId(_ id: Model.IdValue) -> DuetQuery<Model> {
    .init(db: db, constraints: constraints + ["id" == .uuid(id)], limit: limit, order: order)
  }

  func `where`(_ constraints: SQL.WhereConstraint...) -> DuetQuery<Model> {
    .init(db: db, constraints: self.constraints + constraints, limit: limit, order: order)
  }

  func `where`(_ constraints: [SQL.WhereConstraint]) -> DuetQuery<Model> {
    .init(db: db, constraints: self.constraints + constraints, limit: limit, order: order)
  }

  func limit(_ limit: Int?) -> DuetQuery<Model> {
    .init(db: db, constraints: constraints, limit: limit, order: order)
  }

  func orderBy(_ order: SQL.Order?) -> DuetQuery<Model> {
    .init(
      db: db,
      constraints: constraints,
      limit: limit,
      order: order
    )
  }

  func orderBy(_ column: String, by direction: SQL.OrderDirection) -> DuetQuery<Model> {
    .init(
      db: db,
      constraints: constraints,
      limit: limit,
      order: (column: column, direction: direction)
    )
  }

  func delete() async throws -> [Model] {
    let models = try await db.select(Model.self, where: constraints, orderBy: order, limit: limit)
    // @TODO implment
    return models
  }

  func deleteOne() async throws -> Model {
    let models = try await db.select(Model.self, where: constraints, orderBy: order, limit: limit)
    guard models.count == 1 else { throw DbError.tooManyResultsForDeleteOne }
    // @TODO implment
    return try models.firstOrThrowNotFound()
  }

  func all() async throws -> [Model] {
    try await db.select(Model.self, where: constraints, orderBy: order, limit: limit)
  }

  func first() async throws -> Model {
    try await db.select(Model.self, where: constraints, orderBy: order, limit: limit)
      .firstOrThrowNotFound()
  }
}

enum RelationError: Error {
  case notLoaded
}

enum Children<C: AppModel>: Codable {
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

enum Parent<P: AppModel> {
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

enum OptionalParent<P: AppModel> {
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

  func require(file: StaticString = #file, line: UInt = #line) -> P {
    guard let model = try? model else {
      invariant("Required optional parent \(P.self) not loaded at \(file):\(line)")
    }
    return model
  }
}

enum OptionalChild<C: AppModel> {
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

  func require(file: StaticString = #file, line: UInt = #line) -> C {
    guard let model = try? model else {
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

protocol DuetModel: UUIDIdentifiable, SQLInspectable, AppModel {
  associatedtype IdValue: RandomEmptyInitializing, UUIDStringable, Hashable
  var id: IdValue { get set }
  associatedtype ColumnName: CodingKey
  static func columnName(_ column: ColumnName) -> String
  static var tableName: String { get }
  var insertValues: [String: Postgres.Data] { get }
}

extension DuetModel {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
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
    guard let first = first else { throw DbError.notFound }
    return first
  }
}

protocol SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint) -> Bool
}

extension SQLInspectable {
  func satisfies(constraint: SQL.WhereConstraint?) -> Bool {
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
