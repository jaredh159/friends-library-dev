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
  let childFk: UUIDStringable
  switch keyPath {

    case \Edition.document:
      childFk = (child as! Edition).documentId

    case \EditionChapter.edition:
      childFk = (child as! EditionChapter).editionId

    case \EditionImpression.edition:
      childFk = (child as! EditionImpression).editionId

    case \Download.edition:
      childFk = (child as! Download).editionId

    case \Document.friend:
      childFk = (child as! Document).friendId

    case \RelatedDocument.parentDocument:
      childFk = (child as! RelatedDocument).parentDocumentId

    case \RelatedDocument.document:
      childFk = (child as! RelatedDocument).documentId

    case \DocumentTag.document:
      childFk = (child as! DocumentTag).documentId

    case \FriendQuote.friend:
      childFk = (child as! FriendQuote).friendId

    case \FriendResidence.friend:
      childFk = (child as! FriendResidence).friendId

    case \FriendResidenceDuration.residence:
      childFk = (child as! FriendResidenceDuration).friendResidenceId

    case \Audio.edition:
      childFk = (child as! Audio).editionId

    case \AudioPart.audio:
      childFk = (child as! AudioPart).audioId

    case \OrderItem.edition:
      childFk = (child as! OrderItem).editionId

    case \OrderItem.order:
      childFk = (child as! OrderItem).orderId

    case \TokenScope.token:
      childFk = (child as! TokenScope).tokenId

    default:
      throw Abort(.notImplemented, reason: "\(keyPath) not handled for Parent<M> relation")
  }
  let parent = try await Current.db.query(P.self).where("id" == childFk).first()
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
