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
      at: resolveChildren { document, eventLoop -> Future<[Document]> in
        switch document.relatedDocuments {
          case .notLoaded:
            return future(of: [Document].self, on: eventLoop) {
              fatalError("not implemented")
            }
          case let .loaded(documentChildren):
            return eventLoop.makeSucceededFuture(documentChildren)
        }
      },
      as: [TypeRef<Document>].self)
  }
}

