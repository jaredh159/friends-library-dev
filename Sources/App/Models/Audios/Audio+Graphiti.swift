import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Audio {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToChildren<AudioPart>
  ) where FieldType == [TypeRef<AudioPart>] {
    self.init(
      name.description,
      at: resolveChildren { (audio) async throws -> [AudioPart] in
        switch audio.parts {
          case .notLoaded:
            return try await Current.db.getAudioAudioParts(audio.id)
          case let .loaded(audioChildren):
            return audioChildren
        }
      },
      as: [TypeRef<AudioPart>].self)
  }
}

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: Audio {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<Edition>
  ) where FieldType == TypeRef<Edition> {
    self.init(
      name.description,
      at: resolveParent { (audio) async throws -> Edition in
        switch audio.edition {
          case .notLoaded:
            return try await Current.db.getEdition(audio.editionId)
          case let .loaded(edition):
            return edition
        }
      },
      as: TypeReference<Edition>.self)
  }
}
