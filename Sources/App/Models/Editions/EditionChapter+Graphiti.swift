import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: EditionChapter {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<Edition>
  ) where FieldType == TypeRef<Edition> {
    self.init(
      name.description,
      at: resolveParent { (editionChapter) async throws -> Edition in
        switch editionChapter.edition {
          case .notLoaded:
            // @NEXT
            fatalError("EditionChapter -> Parent<Edition> not implemented")
          case let .loaded(edition):
            return edition
        }
      },
      as: TypeReference<Edition>.self)
  }
}
