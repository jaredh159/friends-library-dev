// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension AppSchema {
  static var AudioPartType: AppType<AudioPart> {
    Type(AudioPart.self) {
      Field("id", at: \.id.rawValue)
      Field("audioId", at: \.audioId.rawValue)
      Field("title", at: \.title)
      Field("duration", at: \.duration.rawValue)
      Field("chapters", at: \.chapters.rawValue)
      Field("order", at: \.order)
      Field("mp3SizeHq", at: \.mp3SizeHq.rawValue)
      Field("mp3SizeLq", at: \.mp3SizeLq.rawValue)
      Field("externalIdHq", at: \.externalIdHq.rawValue)
      Field("externalIdLq", at: \.externalIdLq.rawValue)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
      Field("audio", with: \.audio)
    }
  }

  struct CreateAudioPartInput: Codable {
    let id: UUID?
    let audioId: UUID
    let title: String
    let duration: Double
    let chapters: [Int]
    let order: Int
    let mp3SizeHq: Int
    let mp3SizeLq: Int
    let externalIdHq: Int64
    let externalIdLq: Int64
  }

  struct UpdateAudioPartInput: Codable {
    let id: UUID
    let audioId: UUID
    let title: String
    let duration: Double
    let chapters: [Int]
    let order: Int
    let mp3SizeHq: Int
    let mp3SizeLq: Int
    let externalIdHq: Int64
    let externalIdLq: Int64
  }

  struct CreateAudioPartArgs: Codable {
    let input: AppSchema.CreateAudioPartInput
  }

  struct UpdateAudioPartArgs: Codable {
    let input: AppSchema.UpdateAudioPartInput
  }

  struct CreateAudioPartsArgs: Codable {
    let input: [AppSchema.CreateAudioPartInput]
  }

  struct UpdateAudioPartsArgs: Codable {
    let input: [AppSchema.UpdateAudioPartInput]
  }

  static var CreateAudioPartInputType: AppInput<AppSchema.CreateAudioPartInput> {
    Input(AppSchema.CreateAudioPartInput.self) {
      InputField("id", at: \.id)
      InputField("audioId", at: \.audioId)
      InputField("title", at: \.title)
      InputField("duration", at: \.duration)
      InputField("chapters", at: \.chapters)
      InputField("order", at: \.order)
      InputField("mp3SizeHq", at: \.mp3SizeHq)
      InputField("mp3SizeLq", at: \.mp3SizeLq)
      InputField("externalIdHq", at: \.externalIdHq)
      InputField("externalIdLq", at: \.externalIdLq)
    }
  }

  static var UpdateAudioPartInputType: AppInput<AppSchema.UpdateAudioPartInput> {
    Input(AppSchema.UpdateAudioPartInput.self) {
      InputField("id", at: \.id)
      InputField("audioId", at: \.audioId)
      InputField("title", at: \.title)
      InputField("duration", at: \.duration)
      InputField("chapters", at: \.chapters)
      InputField("order", at: \.order)
      InputField("mp3SizeHq", at: \.mp3SizeHq)
      InputField("mp3SizeLq", at: \.mp3SizeLq)
      InputField("externalIdHq", at: \.externalIdHq)
      InputField("externalIdLq", at: \.externalIdLq)
    }
  }

  static var getAudioPart: AppField<AudioPart, IdentifyEntityArgs> {
    Field("getAudioPart", at: Resolver.getAudioPart) {
      Argument("id", at: \.id)
    }
  }

  static var getAudioParts: AppField<[AudioPart], NoArgs> {
    Field("getAudioParts", at: Resolver.getAudioParts)
  }

  static var createAudioPart: AppField<AudioPart, AppSchema.CreateAudioPartArgs> {
    Field("createAudioPart", at: Resolver.createAudioPart) {
      Argument("input", at: \.input)
    }
  }

  static var createAudioParts: AppField<[AudioPart], AppSchema.CreateAudioPartsArgs> {
    Field("createAudioParts", at: Resolver.createAudioParts) {
      Argument("input", at: \.input)
    }
  }

  static var updateAudioPart: AppField<AudioPart, AppSchema.UpdateAudioPartArgs> {
    Field("updateAudioPart", at: Resolver.updateAudioPart) {
      Argument("input", at: \.input)
    }
  }

  static var updateAudioParts: AppField<[AudioPart], AppSchema.UpdateAudioPartsArgs> {
    Field("updateAudioParts", at: Resolver.updateAudioParts) {
      Argument("input", at: \.input)
    }
  }

  static var deleteAudioPart: AppField<AudioPart, IdentifyEntityArgs> {
    Field("deleteAudioPart", at: Resolver.deleteAudioPart) {
      Argument("id", at: \.id)
    }
  }
}

extension AudioPart {
  convenience init(_ input: AppSchema.CreateAudioPartInput) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      audioId: .init(rawValue: input.audioId),
      title: input.title,
      duration: .init(rawValue: input.duration),
      chapters: try NonEmpty<[Int]>.fromArray(input.chapters),
      order: input.order,
      mp3SizeHq: .init(rawValue: input.mp3SizeHq),
      mp3SizeLq: .init(rawValue: input.mp3SizeLq),
      externalIdHq: .init(rawValue: input.externalIdHq),
      externalIdLq: .init(rawValue: input.externalIdLq)
    )
  }

  convenience init(_ input: AppSchema.UpdateAudioPartInput) throws {
    self.init(
      id: .init(rawValue: input.id),
      audioId: .init(rawValue: input.audioId),
      title: input.title,
      duration: .init(rawValue: input.duration),
      chapters: try NonEmpty<[Int]>.fromArray(input.chapters),
      order: input.order,
      mp3SizeHq: .init(rawValue: input.mp3SizeHq),
      mp3SizeLq: .init(rawValue: input.mp3SizeLq),
      externalIdHq: .init(rawValue: input.externalIdHq),
      externalIdLq: .init(rawValue: input.externalIdLq)
    )
  }

  func update(_ input: AppSchema.UpdateAudioPartInput) throws {
    self.audioId = .init(rawValue: input.audioId)
    self.title = input.title
    self.duration = .init(rawValue: input.duration)
    self.chapters = try NonEmpty<[Int]>.fromArray(input.chapters)
    self.order = input.order
    self.mp3SizeHq = .init(rawValue: input.mp3SizeHq)
    self.mp3SizeLq = .init(rawValue: input.mp3SizeLq)
    self.externalIdHq = .init(rawValue: input.externalIdHq)
    self.externalIdLq = .init(rawValue: input.externalIdLq)
    self.updatedAt = Current.date()
  }
}
