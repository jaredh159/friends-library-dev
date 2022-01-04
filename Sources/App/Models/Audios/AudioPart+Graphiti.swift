import Fluent
import Graphiti
import Vapor

extension Graphiti.Field where Arguments == NoArgs, Context == Req, ObjectType: AudioPart {
  convenience init(
    _ name: FieldKey,
    with keyPath: ToParent<Audio>
  ) where FieldType == TypeRef<Audio> {
    self.init(
      name.description,
      at: resolveParent { (audioPart) async throws -> Audio in
        switch audioPart.audio {
          case .notLoaded:
            fatalError("AudioPart -> Parent<Audio> not implemented")
          case let .loaded(audio):
            return audio
        }
      },
      as: TypeReference<Audio>.self)
  }
}
