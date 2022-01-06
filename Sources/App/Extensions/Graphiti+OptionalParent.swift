import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: DuetModel {
  convenience init<Child: DuetModel>(
    _ name: FieldKey,
    with keyPath: ToOptionalParent<Child>
  ) where FieldType == TypeRef<Child>? {
    self.init(
      name.description,
      at: resolveOptionalParent { (child) async throws -> Child? in
        switch child[keyPath: keyPath] {
          case let .loaded(parent):
            return parent
          case .notLoaded:
            return try await loadOptionalParent(at: keyPath, for: child)
        }
      },
      as: TypeReference<Child>?.self)
  }
}

private func loadOptionalParent<Child: DuetModel, Parent: DuetModel>(
  at keyPath: WritableKeyPath<Child, OptionalParent<Parent>>,
  for child: Child
) async throws -> Parent? {
  let db = Current.db
  let parent: Parent?
  switch keyPath {

    case \Document.altLanguageDocument:
      let document = child as! Document
      guard let altLanguageDocumentId = document.altLanguageId else { return nil }
      parent = try? await db.getDocument(altLanguageDocumentId) as! Parent?

    case \Isbn.edition:
      let isbn = child as! Isbn
      guard let editionId = isbn.editionId else { return nil }
      parent = try? await db.getEdition(editionId) as! Parent?

    case \Order.freeOrderRequest:
      let order = child as! Order
      guard let freeOrderRequestId = order.freeOrderRequestId else { return nil }
      parent = try? await db.getFreeOrderRequest(freeOrderRequestId) as! Parent?

    default:
      throw Abort(.notImplemented, reason: "\(keyPath) not handled for OptionalParent<M> relation")
  }

  var child = child
  child[keyPath: keyPath] = .loaded(parent)
  return parent
}

private func resolveOptionalParent<M: AppModel, P: AppModel>(
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
