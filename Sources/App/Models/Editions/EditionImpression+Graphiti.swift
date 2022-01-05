import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: EditionImpression {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<Edition>
  ) where FieldType == TypeRef<Edition> {
    self.init(
      name.description,
      at: resolveParent { (editionImpression) async throws -> Edition in
        switch editionImpression.edition {
          case .notLoaded:
            return try await Current.db.getEdition(editionImpression.editionId)
          case let .loaded(edition):
            return edition
        }
      },
      as: TypeReference<Edition>.self)
  }
}
