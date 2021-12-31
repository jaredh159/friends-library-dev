import Graphiti
import Vapor

extension Graphiti.Field {
  typealias TypeRef = TypeReference
  typealias ToChildren<M: AppModel> = KeyPath<ObjectType, Children<M>>
}

func resolveChildren<P: AppModel, C: AppModel>(
  _ f: @escaping (P, EventLoop) throws -> Future<[C]>
) -> (P) -> (Req, NoArgs, EventLoopGroup) throws -> Future<[C]> {
  { parent in
    { _, _, elg in
      try f(parent, elg.next())
    }
  }
}
