import Fluent
import Graphiti
import Vapor

extension Graphiti.Field {
  typealias TypeRef = TypeReference
  typealias ToChildren<M: ApiModel> = WritableKeyPath<ObjectType, Children<M>>
  typealias ToOptionalChild<M: ApiModel> = WritableKeyPath<ObjectType, OptionalChild<M>>
  typealias ToOptionalParent<M: ApiModel> = WritableKeyPath<ObjectType, OptionalParent<M>>
  typealias ToParent<M: ApiModel> = WritableKeyPath<ObjectType, Parent<M>>
}

// helpers
