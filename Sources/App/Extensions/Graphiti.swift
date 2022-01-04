import Graphiti
import Vapor

extension Graphiti.Field {
  typealias TypeRef = TypeReference
  typealias ToChildren<M: AppModel> = KeyPath<ObjectType, Children<M>>
  typealias ToOptionalChild<M: AppModel> = KeyPath<ObjectType, OptionalChild<M>>
  typealias ToOptionalParent<M: AppModel> = KeyPath<ObjectType, OptionalParent<M>>
  typealias ToParent<M: AppModel> = KeyPath<ObjectType, Parent<M>>
}

func resolveChildren<P: AppModel, C: AppModel>(
  _ f: @escaping (P) async throws -> [C]
) -> (P) -> (Req, NoArgs, EventLoopGroup) throws -> Future<[C]> {
  { parent in
    { _, _, elg in
      return future(of: [C].self, on: elg.next()) {
        try await f(parent)
      }
    }
  }
}

func resolveOptionalChild<Parent: AppModel, Child: AppModel>(
  _ f: @escaping (Parent) async throws -> Child?
) -> (Parent) -> (Req, NoArgs, EventLoopGroup) throws -> Future<Child?> {
  { parent in
    { _, _, elg in
      return future(of: Child?.self, on: elg.next()) {
        try await f(parent)
      }
    }
  }
}

func resolveParent<M: AppModel, P: AppModel>(
  _ f: @escaping (M) async throws -> P
) -> (M) -> (Req, NoArgs, EventLoopGroup) throws -> Future<P> {
  { model in
    { _, _, elg in
      return future(of: P.self, on: elg.next()) {
        try await f(model)
      }
    }
  }
}

func resolveOptionalParent<M: AppModel, P: AppModel>(
  _ f: @escaping (M) async throws -> P?
) -> (M) -> (Req, NoArgs, EventLoopGroup) throws -> Future<P?> {
  { model in
    { _, _, elg in
      return future(of: P?.self, on: elg.next()) {
        try await f(model)
      }
    }
  }
}
