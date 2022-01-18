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
  let foreignKey: Child.ColumnName
  switch keyPath {

    case \Friend.documents:
      foreignKey = try Child.column(Document[.friendId])

    case \Friend.residences:
      foreignKey = try Child.column(FriendResidence[.friendId])

    case \Friend.quotes:
      foreignKey = try Child.column(FriendQuote[.friendId])

    case \FriendResidence.durations:
      foreignKey = try Child.column(FriendResidenceDuration[.friendResidenceId])

    case \Edition.chapters:
      foreignKey = try Child.column(EditionChapter[.editionId])

    case \Document.editions:
      foreignKey = try Child.column(Edition[.documentId])

    case \Document.relatedDocuments:
      foreignKey = try Child.column(RelatedDocument[.parentDocumentId])

    case \Document.tags:
      foreignKey = try Child.column(DocumentTag[.documentId])

    case \Audio.parts:
      foreignKey = try Child.column(AudioPart[.audioId])

    case \Order.items:
      foreignKey = try Child.column(OrderItem[.orderId])

    case \Token.scopes:
      foreignKey = try Child.column(TokenScope[.tokenId])

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

private func resolveChildren<P: ApiModel, C: ApiModel>(
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
