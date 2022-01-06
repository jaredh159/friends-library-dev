import Fluent
import Graphiti
import Vapor

extension Graphiti.Field {
  typealias TypeRef = TypeReference
  typealias ToChildren<M: AppModel> = WritableKeyPath<ObjectType, Children<M>>
  typealias ToOptionalChild<M: AppModel> = WritableKeyPath<ObjectType, OptionalChild<M>>
  typealias ToOptionalParent<M: AppModel> = WritableKeyPath<ObjectType, OptionalParent<M>>
  typealias ToParent<M: AppModel> = WritableKeyPath<ObjectType, Parent<M>>
}

// helpers
