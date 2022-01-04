import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Download {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<Edition>
  ) where FieldType == TypeRef<Edition> {
    self.init(
      name.description,
      at: resolveParent { (download) async throws -> Edition in
        switch download.edition {
          case .notLoaded:
            fatalError("Download -> Parent<Edition> not implemented")
          case let .loaded(edition):
            return edition
        }
      },
      as: TypeReference<Edition>.self)
  }
}
