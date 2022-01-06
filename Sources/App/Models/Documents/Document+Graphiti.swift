import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Document {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToChildren<Edition>
  ) where FieldType == [TypeRef<Edition>] {
    self.init(
      name.description,
      at: resolveChildren { (document) async throws -> [Edition] in
        switch document.editions {
          case .notLoaded:
            return try await Current.db.getEditions(Edition[.documentId] == .id(document))
          case let .loaded(editions):
            return editions
        }
      },
      as: [TypeRef<Edition>].self)
  }
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Document {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<Friend>
  ) where FieldType == TypeRef<Friend> {
    self.init(
      name.description,
      at: resolveParent { (document) async throws -> Friend in
        switch document.friend {
          case .notLoaded:
            return try await Current.db.getFriend(document.friendId)
          case let .loaded(friend):
            return friend
        }
      },
      as: TypeReference<Friend>.self)
  }
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Document {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToOptionalParent<Document>
  ) where FieldType == TypeRef<Document>? {
    self.init(
      name.description,
      at: resolveOptionalParent { (document) async throws -> Document? in
        switch document.altLanguageDocument {
          case .notLoaded:
            guard let altLanguageDocumentId = document.altLanguageId else { return nil }
            return try await Current.db.getDocument(altLanguageDocumentId)
          case let .loaded(altLanguageDocument):
            return altLanguageDocument
        }
      },
      as: TypeReference<Document>?.self)
  }
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Document {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToChildren<Document>
  ) where FieldType == [TypeRef<Document>] {
    self.init(
      name.description,
      at: resolveChildren { (document) async throws -> [Document] in
        switch document.relatedDocuments {
          case .notLoaded:
            fatalError("not implemented")
          case let .loaded(documentChildren):
            return documentChildren
        }
      },
      as: [TypeRef<Document>].self)
  }
}
