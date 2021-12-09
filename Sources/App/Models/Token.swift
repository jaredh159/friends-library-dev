import Fluent
import Tagged
import Vapor

final class Token: FlpModel {
  typealias Id = Tagged<(Token, id: ()), UUID>
  typealias Value = Tagged<(Token, Value: ()), UUID>

  static let schema = M4.tableName

  @ID(custom: .id, generatedBy: .user)
  var id: Id?

  @Field(key: M4.value)
  var value: Value

  @Field(key: M4.description)
  var description: String

  @Timestamp(key: .createdAt, on: .create)
  var createdAt: Date?

  @Children(for: \TokenScope.$token)
  var scopes: [TokenScope]

  init() {}

  init(
    id: Id? = nil,
    value: Value? = nil,
    description: String,
    createdAt: Date? = nil
  ) {
    self.id = id ?? .init(rawValue: UUID())
    self.value = value ?? .init(rawValue: UUID())
    self.description = description
    self.createdAt = createdAt ?? Date()
  }

}

extension Token {
  enum M4 {
    static let tableName = "tokens"
    static let value = FieldKey("value")
    static let description = FieldKey("description")
  }
}
