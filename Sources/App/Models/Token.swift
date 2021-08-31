import Fluent
import Vapor

final class Token: Model, Content {
  static let schema = "tokens"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "value")
  var value: UUID

  @Field(key: "description")
  var description: String

  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?

  @Children(for: \TokenScope.$token)
  var scopes: [TokenScope]

  init() {}

  init(
    id: UUID? = nil,
    value: UUID? = nil,
    description: String,
    createdAt: Date? = nil
  ) {
    self.id = id
    self.value = value ?? UUID()
    self.description = description
    self.createdAt = createdAt ?? Date()
  }
}
