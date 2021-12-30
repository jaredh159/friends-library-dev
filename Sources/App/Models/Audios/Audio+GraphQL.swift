// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension Audio {
  enum GraphQL {
    enum Schema {
      enum Inputs {}
      enum Queries {}
      enum Mutations {}
    }
    enum Request {
      enum Inputs {}
      enum Args {}
    }
  }
}

extension Audio.GraphQL.Schema {
  static var type: AppType<Audio> {
    Type(Audio.self) {
      Field("id", at: \.id.rawValue)
      Field("editionId", at: \.editionId.rawValue)
      Field("reader", at: \.reader)
      Field("isIncomplete", at: \.isIncomplete)
      Field("mp3ZipSizeHq", at: \.mp3ZipSizeHq.rawValue)
      Field("mp3ZipSizeLq", at: \.mp3ZipSizeLq.rawValue)
      Field("m4bSizeHq", at: \.m4bSizeHq.rawValue)
      Field("m4bSizeLq", at: \.m4bSizeLq.rawValue)
      Field("externalPlaylistIdHq", at: \.externalPlaylistIdHq?.rawValue)
      Field("externalPlaylistIdLq", at: \.externalPlaylistIdLq?.rawValue)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
    }
  }
}

extension Audio.GraphQL.Request.Inputs {
  struct Create: Codable {
    let id: UUID?
    let editionId: UUID
    let reader: String
    let isIncomplete: Bool
    let mp3ZipSizeHq: Int
    let mp3ZipSizeLq: Int
    let m4bSizeHq: Int
    let m4bSizeLq: Int
    let externalPlaylistIdHq: Int64?
    let externalPlaylistIdLq: Int64?
  }

  struct Update: Codable {
    let id: UUID
    let editionId: UUID
    let reader: String
    let isIncomplete: Bool
    let mp3ZipSizeHq: Int
    let mp3ZipSizeLq: Int
    let m4bSizeHq: Int
    let m4bSizeLq: Int
    let externalPlaylistIdHq: Int64?
    let externalPlaylistIdLq: Int64?
  }
}

extension Audio.GraphQL.Request.Args {
  struct Create: Codable {
    let input: Audio.GraphQL.Request.Inputs.Create
  }

  struct Update: Codable {
    let input: Audio.GraphQL.Request.Inputs.Update
  }

  struct UpdateMany: Codable {
    let input: [Audio.GraphQL.Request.Inputs.Update]
  }

  struct CreateMany: Codable {
    let input: [Audio.GraphQL.Request.Inputs.Create]
  }
}

extension Audio.GraphQL.Schema.Inputs {
  static var create: AppInput<Audio.GraphQL.Request.Inputs.Create> {
    Input(Audio.GraphQL.Request.Inputs.Create.self) {
      InputField("id", at: \.id)
      InputField("editionId", at: \.editionId)
      InputField("reader", at: \.reader)
      InputField("isIncomplete", at: \.isIncomplete)
      InputField("mp3ZipSizeHq", at: \.mp3ZipSizeHq)
      InputField("mp3ZipSizeLq", at: \.mp3ZipSizeLq)
      InputField("m4bSizeHq", at: \.m4bSizeHq)
      InputField("m4bSizeLq", at: \.m4bSizeLq)
      InputField("externalPlaylistIdHq", at: \.externalPlaylistIdHq)
      InputField("externalPlaylistIdLq", at: \.externalPlaylistIdLq)
    }
  }

  static var update: AppInput<Audio.GraphQL.Request.Inputs.Update> {
    Input(Audio.GraphQL.Request.Inputs.Update.self) {
      InputField("id", at: \.id)
      InputField("editionId", at: \.editionId)
      InputField("reader", at: \.reader)
      InputField("isIncomplete", at: \.isIncomplete)
      InputField("mp3ZipSizeHq", at: \.mp3ZipSizeHq)
      InputField("mp3ZipSizeLq", at: \.mp3ZipSizeLq)
      InputField("m4bSizeHq", at: \.m4bSizeHq)
      InputField("m4bSizeLq", at: \.m4bSizeLq)
      InputField("externalPlaylistIdHq", at: \.externalPlaylistIdHq)
      InputField("externalPlaylistIdLq", at: \.externalPlaylistIdLq)
    }
  }
}

extension Audio.GraphQL.Schema.Queries {
  static var get: AppField<Audio, IdentifyEntityArgs> {
    Field("getAudio", at: Resolver.getAudio) {
      Argument("id", at: \.id)
    }
  }

  static var list: AppField<[Audio], NoArgs> {
    Field("getAudios", at: Resolver.getAudios)
  }
}

extension Audio.GraphQL.Schema.Mutations {
  static var create: AppField<Audio, Audio.GraphQL.Request.Args.Create> {
    Field("createAudio", at: Resolver.createAudio) {
      Argument("input", at: \.input)
    }
  }

  static var createMany: AppField<[Audio], Audio.GraphQL.Request.Args.CreateMany> {
    Field("createAudio", at: Resolver.createAudios) {
      Argument("input", at: \.input)
    }
  }

  static var update: AppField<Audio, Audio.GraphQL.Request.Args.Update> {
    Field("createAudio", at: Resolver.updateAudio) {
      Argument("input", at: \.input)
    }
  }

  static var updateMany: AppField<[Audio], Audio.GraphQL.Request.Args.UpdateMany> {
    Field("createAudio", at: Resolver.updateAudios) {
      Argument("input", at: \.input)
    }
  }

  static var delete: AppField<Audio, IdentifyEntityArgs> {
    Field("deleteAudio", at: Resolver.deleteAudio) {
      Argument("id", at: \.id)
    }
  }
}

extension Audio {
  convenience init(_ input: Audio.GraphQL.Request.Inputs.Create) throws {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      editionId: .init(rawValue: input.editionId),
      reader: input.reader,
      mp3ZipSizeHq: .init(rawValue: input.mp3ZipSizeHq),
      mp3ZipSizeLq: .init(rawValue: input.mp3ZipSizeLq),
      m4bSizeHq: .init(rawValue: input.m4bSizeHq),
      m4bSizeLq: .init(rawValue: input.m4bSizeLq),
      externalPlaylistIdHq: input.externalPlaylistIdHq != nil ? .init(rawValue: input.externalPlaylistIdHq!) : nil,
      externalPlaylistIdLq: input.externalPlaylistIdLq != nil ? .init(rawValue: input.externalPlaylistIdLq!) : nil,
      isIncomplete: input.isIncomplete
    )
  }

  func update(_ input: Audio.GraphQL.Request.Inputs.Update) throws {
    self.editionId = .init(rawValue: input.editionId)
    self.reader = input.reader
    self.isIncomplete = input.isIncomplete
    self.mp3ZipSizeHq = .init(rawValue: input.mp3ZipSizeHq)
    self.mp3ZipSizeLq = .init(rawValue: input.mp3ZipSizeLq)
    self.m4bSizeHq = .init(rawValue: input.m4bSizeHq)
    self.m4bSizeLq = .init(rawValue: input.m4bSizeLq)
    self.externalPlaylistIdHq = input.externalPlaylistIdHq != nil ? .init(rawValue: input.externalPlaylistIdHq!) : nil
    self.externalPlaylistIdLq = input.externalPlaylistIdLq != nil ? .init(rawValue: input.externalPlaylistIdLq!) : nil
    self.updatedAt = Current.date()
  }
}
