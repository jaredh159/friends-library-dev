import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: RelatedDocument {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<Document>
  ) where FieldType == TypeRef<Document> {
    self.init(
      name.description,
      at: resolveParent { (relatedDocument) async throws -> Document in
        switch relatedDocument.document {
          case .notLoaded:
            fatalError("RelatedDocument -> Parent<Document> not implemented")
          case let .loaded(document):
            return document
        }
      },
      as: TypeReference<Document>.self)
  }
}
