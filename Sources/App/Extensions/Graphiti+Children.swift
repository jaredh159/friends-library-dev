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
      at: resolveChildren { parent async throws -> [Child] in
        switch parent[keyPath: keyPath] {
          case .loaded(let children):
            return children
          case .notLoaded:
            return try await loadChildren(at: keyPath, for: parent)
        }
      },
      as: [TypeRef<Child>].self
    )
  }
}

private func loadChildren<Parent: DuetModel, Child: DuetModel>(
  at keyPath: WritableKeyPath<Parent, Children<Child>>,
  for parent: Parent
) async throws -> [Child] {
  let foreignKey: String
  switch keyPath {

    case \Friend.documents:
      foreignKey = Document[.friendId]

    case \Friend.residences:
      foreignKey = FriendResidence[.friendId]

    case \Friend.quotes:
      foreignKey = FriendQuote[.friendId]

    case \FriendResidence.durations:
      foreignKey = FriendResidenceDuration[.friendResidenceId]

    case \Edition.chapters:
      foreignKey = EditionChapter[.editionId]

    case \Document.editions:
      foreignKey = Edition[.documentId]

    case \Document.relatedDocuments:
      foreignKey = RelatedDocument[.parentDocumentId]

    case \Document.tags:
      foreignKey = DocumentTag[.documentId]

    case \Audio.parts:
      foreignKey = AudioPart[.audioId]

    case \Order.items:
      foreignKey = OrderItem[.orderId]

    case \Token.scopes:
      foreignKey = TokenScope[.tokenId]

    default:
      throw Abort(.notImplemented, reason: "\(keyPath) not handled for Children<M> relation")
  }

  let children = try await Current.db.query(Child.self)
    .where(foreignKey == .id(parent))
    .all()

  var parent = parent
  parent[keyPath: keyPath] = .loaded(children)
  return children
}

private func resolveChildren<P: AppModel, C: AppModel>(
  _ f: @escaping (P) async throws -> [C]
) -> (P) -> (Req, NoArgs, EventLoopGroup) throws -> Future<[C]> {
  { parent in
    { _, _, elg in
      future(of: [C].self, on: elg.next()) {
        try await f(parent)
      }
    }
  }
}
