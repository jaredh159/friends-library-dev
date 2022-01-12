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
  let db = Current.db
  let child: Child?
  switch keyPath {

    case \Edition.isbn:
      child = try await db.getEditionIsbn(parent.id as! Edition.Id) as! Child?

    case \Edition.audio:
      child = try? await db.entities()
        .find(Child.self, where: Audio[.editionId] == .id(parent))

    case \Edition.impression:
      child = try await db.entities()
        .findOptional(Child.self, where: EditionImpression[.editionId] == .id(parent))

    default:
      throw Abort(.notImplemented, reason: "\(keyPath) not handled for OptionalChild<M> relation")
  }

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
