import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Isbn {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToOptionalParent<Edition>
  ) where FieldType == TypeRef<Edition>? {
    self.init(
      name.description,
      at: resolveOptionalParent { (isbn) async throws -> Edition? in
        switch isbn.edition {
          case .notLoaded:
            guard let editionId = isbn.editionId else { return nil }
            return try await Current.db.getEdition(editionId)
          case let .loaded(edition):
            return edition
        }
      },
      as: TypeReference<Edition>?.self)
  }
}
