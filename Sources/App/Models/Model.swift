import Foundation
import NIO
import Tagged

protocol AppModel: Codable, Equatable, RandomIdInitializable {}

enum Children<C: AppModel> {
  case notLoaded
  case loaded([C])
}

enum Parent<M: AppModel> {
  case notLoaded
  case loaded(M)
}

extension AppModel where IdValue: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }
}

protocol RandomIdInitializable {
  associatedtype IdValue: RandomEmptyInitializing
  var id: IdValue { get set }
}

protocol DuetModel: RandomIdInitializable, Codable {
  associatedtype ColumnName: CodingKey
  static func columnName(_ column: ColumnName) -> String
  static var tableName: String { get }
}

extension DuetModel where ColumnName: RawRepresentable, ColumnName.RawValue == String {
  static func columnName(_ column: ColumnName) -> String {
    column.rawValue.snakeCased
  }

  static subscript(_ column: ColumnName) -> String {
    columnName(column)
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
