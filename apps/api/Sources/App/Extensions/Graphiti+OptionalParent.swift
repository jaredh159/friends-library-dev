import DuetSQL
import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: ApiModel {
  convenience init<Child: ApiModel>(
    _ name: FieldKey,
    with keyPath: ToOptionalParent<Child>
  ) where FieldType == TypeRef<Child>? {
    self.init(
      name.description,
      at: resolveOptionalParent { child async throws -> Child? in
        switch child[keyPath: keyPath] {
        case .loaded(let parent):
          return parent
        case .notLoaded:
          return try await loadOptionalParent(at: keyPath, for: child)
        }
      },
      as: TypeReference<Child>?.self
    )
  }
}

private func loadOptionalParent<Child: ApiModel, Parent: ApiModel>(
  at keyPath: WritableKeyPath<Child, OptionalParent<Parent>>,
  for child: Child
) async throws -> Parent? {
  let db = Current.db
  var parent: Parent?
  var childFk: UUIDStringable?
  switch keyPath {

  case \Document.altLanguageDocument:
    childFk = (child as! Document).altLanguageId

  case \Isbn.edition:
    childFk = (child as! Isbn).editionId

  case \Order.freeOrderRequest:
    childFk = (child as! Order).freeOrderRequestId

  default:
    throw Abort(.notImplemented, reason: "\(keyPath) not handled for OptionalParent<M> relation")
  }

  if let fk = childFk {
    parent = try? await db.query(Parent.self).where(Parent.column("id") == fk).first()
  }

  var child = child
  child[keyPath: keyPath] = .loaded(parent)
  return parent
}

private func resolveOptionalParent<M: ApiModel, P: ApiModel>(
  _ f: @escaping (M) async throws -> P?
) -> (M) -> (Req, NoArgs, EventLoopGroup) throws -> Future<P?> {
  { model in
    { _, _, elg in
      future(of: P?.self, on: elg.next()) {
        try await f(model)
      }
    }
  }
}
