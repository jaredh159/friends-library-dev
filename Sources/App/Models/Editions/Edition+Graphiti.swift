import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Edition {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<Document>
  ) where FieldType == TypeRef<Document> {
    self.init(
      name.description,
      at: resolveParent { (edition) async throws -> Document in
        switch edition.document {
          case .notLoaded:
            return try await Current.db.getDocument(edition.documentId)
          case let .loaded(document):
            return document
        }
      },
      as: TypeReference<Document>.self)
  }
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Edition {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToOptionalChild<EditionImpression>
  ) where FieldType == TypeRef<EditionImpression>? {
    self.init(
      name.description,
      at: resolveOptionalChild { (edition) async throws -> EditionImpression? in
        switch edition.impression {
          case .notLoaded:
            return try await Current.db.getEditionEditionImpression(edition.id)
          case let .loaded(impression):
            return impression
        }
      },
      as: TypeRef<EditionImpression>?.self)
  }
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Edition {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToOptionalChild<Isbn>
  ) where FieldType == TypeRef<Isbn>? {
    self.init(
      name.description,
      at: resolveOptionalChild { (edition) async throws -> Isbn? in
        switch edition.isbn {
          case .notLoaded:
            return try await Current.db.getEditionIsbn(edition.id)
          case let .loaded(isbn):
            return isbn
        }
      },
      as: TypeRef<Isbn>?.self)
  }
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Edition {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToOptionalChild<Audio>
  ) where FieldType == TypeRef<Audio>? {
    self.init(
      name.description,
      at: resolveOptionalChild { (edition) async throws -> Audio? in
        switch edition.audio {
          case .notLoaded:
            return try await Current.db.getEditionAudio(edition.id)
          case let .loaded(audio):
            return audio
        }
      },
      as: TypeRef<Audio>?.self)
  }
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Edition {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToChildren<EditionChapter>
  ) where FieldType == [TypeRef<EditionChapter>] {
    self.init(
      name.description,
      at: resolveChildren { (edition) async throws -> [EditionChapter] in
        switch edition.chapters {
          case .notLoaded:
            return try await Current.db.getEditionEditionChapters(edition.id)
          case let .loaded(editionChildren):
            return editionChildren
        }
      },
      as: [TypeRef<EditionChapter>].self)
  }
}
