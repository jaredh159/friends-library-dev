import Fluent
import Graphiti
import Vapor

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
            // guard let altLanguageDocumentId = document.altLanguageId else { return nil }
            fatalError("not implemented")
          case let .loaded(altLanguageDocument):
            return altLanguageDocument
        }
      },
      as: TypeReference<Document>?.self)
  }
}
