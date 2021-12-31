import Graphiti
import Vapor

extension Graphiti.Field {
  typealias TypeRef = TypeReference
  typealias ToChildren<M: AppModel> = KeyPath<ObjectType, Children<M>>
  typealias ToOptionalParent<M: AppModel> = KeyPath<ObjectType, OptionalParent<M>>
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
