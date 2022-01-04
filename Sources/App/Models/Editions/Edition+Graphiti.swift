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
            fatalError("Edition -> Parent<Document> not implemented")
          case let .loaded(document):
            return document
        }
      },
      as: TypeReference<Document>.self)
  }
}
