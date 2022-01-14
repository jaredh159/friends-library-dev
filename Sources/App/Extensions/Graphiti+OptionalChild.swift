import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: DuetModel {
  convenience init<Child: DuetModel>(
    _ name: FieldKey,
    with keyPath: ToOptionalChild<Child>
  ) where FieldType == TypeRef<Child>? {
    self.init(
      name.description,
      at: resolveOptionalChild { parent async throws -> Child? in
        switch parent[keyPath: keyPath] {
          case .loaded(let child):
            return child
          case .notLoaded:
            return try await loadOptionalChild(at: keyPath, for: parent)
        }
      },
      as: TypeRef<Child>?.self
    )
  }
}

private func loadOptionalChild<Parent: DuetModel, Child: DuetModel>(
  at keyPath: WritableKeyPath<Parent, OptionalChild<Child>>,
  for parent: Parent
) async throws -> Child? {
  let child = try await Current.db.query(Child.self)
    .where("id" == parent.id)
    .first()

  var parent = parent
  parent[keyPath: keyPath] = .loaded(child)
  return child
}

private func resolveOptionalChild<Parent: AppModel, Child: AppModel>(
  _ f: @escaping (Parent) async throws -> Child?
) -> (Parent) -> (Req, NoArgs, EventLoopGroup) throws -> Future<Child?> {
  { parent in
    { _, _, elg in
      future(of: Child?.self, on: elg.next()) {
        try await f(parent)
      }
    }
  }
}
