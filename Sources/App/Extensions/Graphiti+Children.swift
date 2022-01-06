import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: DuetModel {
  convenience init<Child: DuetModel>(
    _ name: FieldKey,
    with keyPath: ToChildren<Child>
  ) where FieldType == [TypeRef<Child>] {
    self.init(
      name.description,
      at: resolveChildren { (parent) async throws -> [Child] in
        switch parent[keyPath: keyPath] {
          case let .loaded(children):
            return children
          case .notLoaded:
            return try await loadChildren(at: keyPath, for: parent)
        }
      },
      as: [TypeRef<Child>].self)
  }
}

private func loadChildren<Parent: DuetModel, Child: DuetModel>(
  at keyPath: WritableKeyPath<Parent, Children<Child>>,
  for parent: Parent
) async throws -> [Child] {
  let children: [Child]
  let db = Current.db
  switch keyPath {

    case \Friend.documents:
      children = try await db.getDocuments(Document[.friendId] == .id(parent)) as! [Child]

    case \Friend.residences:
      children =
        try await db.getFriendResidences(FriendResidence[.friendId] == .id(parent)) as! [Child]

    case \Friend.quotes:
      children = try await db.getFriendQuotes(FriendQuote[.friendId] == .id(parent)) as! [Child]

    case \FriendResidence.durations:
      children =
        try await db.getFriendResidenceDurations(
          FriendResidenceDuration[.friendResidenceId] == .id(parent)) as! [Child]

    case \Edition.chapters:
      children =
        try await db.getEditionChapters(EditionChapter[.editionId] == .id(parent)) as! [Child]

    case \Document.editions:
      children = try await db.getEditions(Edition[.documentId] == .id(parent)) as! [Child]

    case \Audio.parts:
      children = try await db.getAudioParts(AudioPart[.audioId] == .id(parent)) as! [Child]

    case \Order.items:
      children = try await db.getOrderItems(OrderItem[.orderId] == .id(parent)) as! [Child]

    case \Token.scopes:
      children = try await db.getTokenScopes(TokenScope[.tokenId] == .id(parent)) as! [Child]

    default:
      throw Abort(.notImplemented, reason: "\(keyPath) not handled for OptionalChild<M> relation")
  }

  var parent = parent
  parent[keyPath: keyPath] = .loaded(children)
  return children
}

private func resolveChildren<P: AppModel, C: AppModel>(
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
