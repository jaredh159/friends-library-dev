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
      at: resolveParent { (child) async throws -> Parent in
        switch child[keyPath: keyPath] {
          case let .loaded(parent):
            return parent
          case .notLoaded:
            return try await loadParent(at: keyPath, for: child)
        }
      },
      as: TypeReference<Parent>.self)
  }
}

private func loadParent<Child: DuetModel, P: DuetModel>(
  at keyPath: WritableKeyPath<Child, Parent<P>>,
  for child: Child
) async throws -> P {
  let db = Current.db
  let parent: P
  switch keyPath {

    case \Edition.document:
      let edition = child as! Edition
      parent = try await db.getDocument(edition.documentId) as! P

    case \EditionChapter.edition:
      let chapter = child as! EditionChapter
      parent = try await db.getEdition(chapter.editionId) as! P

    case \EditionImpression.edition:
      let impression = child as! EditionImpression
      parent = try await db.getEdition(impression.editionId) as! P

    case \Download.edition:
      let download = child as! Download
      parent = try await db.getEdition(download.editionId) as! P

    case \Document.friend:
      let document = child as! Document
      parent = try await db.getFriend(document.friendId) as! P

    case \FriendQuote.friend:
      let quote = child as! FriendQuote
      parent = try await db.getFriend(quote.friendId) as! P

    case \FriendResidence.friend:
      let residence = child as! FriendResidence
      parent = try await db.getFriend(residence.friendId) as! P

    case \FriendResidenceDuration.residence:
      let duration = child as! FriendResidenceDuration
      parent = try await db.getFriendResidence(duration.friendResidenceId) as! P

    case \Audio.edition:
      let audio = child as! Audio
      parent = try await db.getEdition(audio.editionId) as! P

    case \AudioPart.audio:
      let audioPart = child as! AudioPart
      parent = try await db.getAudio(audioPart.audioId) as! P

    case \OrderItem.edition:
      let item = child as! OrderItem
      parent = try await db.getEdition(item.editionId) as! P

    case \OrderItem.order:
      let item = child as! OrderItem
      parent = try await db.getOrder(item.orderId) as! P

    default:
      throw Abort(.notImplemented, reason: "\(keyPath) not handled for OptionalChild<M> relation")
  }

  var child = child
  child[keyPath: keyPath] = .loaded(parent)
  return parent
}

private func resolveParent<M: AppModel, P: AppModel>(
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
