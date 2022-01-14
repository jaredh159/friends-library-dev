import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: DuetModel {
  convenience init<Parent: DuetModel>(
    _ name: FieldKey,
    with keyPath: ToParent<Parent>
  ) where FieldType == TypeRef<Parent> {
    self.init(
      name.description,
      at: resolveParent { child async throws -> Parent in
        switch child[keyPath: keyPath] {
          case .loaded(let parent):
            return parent
          case .notLoaded:
            return try await loadParent(at: keyPath, for: child)
        }
      },
      as: TypeReference<Parent>.self
    )
  }
}

private func loadParent<Child: DuetModel, P: DuetModel>(
  at keyPath: WritableKeyPath<Child, Parent<P>>,
  for child: Child
) async throws -> P {
  let parent = try await Current.db.query(P.self).where("id" == child.id).first()
  var child = child
  child[keyPath: keyPath] = .loaded(parent)
  return parent
}

private func resolveParent<M: AppModel, P: AppModel>(
  _ f: @escaping (M) async throws -> P
) -> (M) -> (Req, NoArgs, EventLoopGroup) throws -> Future<P> {
  { model in
    { _, _, elg in
      future(of: P.self, on: elg.next()) {
        try await f(model)
      }
    }
  }
}
