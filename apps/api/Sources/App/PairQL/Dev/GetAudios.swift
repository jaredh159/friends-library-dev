import PairQL

struct GetAudios: Pair {
  static var auth: Scope = .queryEntities

  struct AudioPart: PairNestable {
    var id: App.AudioPart.Id
    var chapters: [Int]
    var durationInSeconds: Double
    var title: String
    var order: Int
    var externalIdHq: Int64
    var externalIdLq: Int64
    var mp3SizeHq: Int
    var mp3SizeLq: Int
  }

  struct Edition: PairNestable {
    var id: App.Edition.Id
    var path: String
    var type: EditionType
    var coverImagePath: String
  }

  struct Document: PairNestable {
    var filename: String
    var title: String
    var slug: String
    var description: String
    var path: String
    var tags: [DocumentTag.TagType]
  }

  struct Friend: PairNestable {
    var lang: Lang
    var name: String
    var slug: String
    var alphabeticalName: String
    var isCompilations: Bool
  }

  struct Audio: PairOutput {
    var id: App.Audio.Id
    var isIncomplete: Bool
    var m4bSizeHq: Int
    var m4bSizeLq: Int
    var mp3ZipSizeHq: Int
    var mp3ZipSizeLq: Int
    var reader: String
    var externalPlaylistIdHq: Int64?
    var externalPlaylistIdLq: Int64?
    var parts: [AudioPart]
    var edition: Edition
    var document: Document
    var friend: Friend
  }

  typealias Output = [Audio]
}

extension GetAudios: NoInputResolver {
  static func resolve(in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let audios = try await App.Audio.query().all()
    return try await audios.concurrentMap { audio in
      async let parts = audio.parts()
      async let edition = audio.edition()
      let document = try await edition.document()
      let friend = try await document.friend()
      return .init(
        id: audio.id,
        isIncomplete: audio.isIncomplete,
        m4bSizeHq: audio.m4bSizeHq.rawValue,
        m4bSizeLq: audio.m4bSizeLq.rawValue,
        mp3ZipSizeHq: audio.mp3ZipSizeHq.rawValue,
        mp3ZipSizeLq: audio.mp3ZipSizeLq.rawValue,
        reader: audio.reader,
        externalPlaylistIdHq: audio.externalPlaylistIdHq?.rawValue,
        externalPlaylistIdLq: audio.externalPlaylistIdLq?.rawValue,
        parts: try await parts.map { part in
          .init(
            id: part.id,
            chapters: Array(part.chapters),
            durationInSeconds: part.duration.rawValue,
            title: part.title,
            order: part.order,
            externalIdHq: part.externalIdHq.rawValue,
            externalIdLq: part.externalIdLq.rawValue,
            mp3SizeHq: part.mp3SizeHq.rawValue,
            mp3SizeLq: part.mp3SizeLq.rawValue
          )
        },
        edition: .init(
          id: try await edition.id,
          path: try await edition.directoryPath,
          type: try await edition.type,
          coverImagePath: try await edition.images.square.w1400.path
        ),
        document: .init(
          filename: document.filename,
          title: document.title,
          slug: document.slug,
          description: document.description,
          path: document.directoryPath,
          tags: []
        ),
        friend: .init(
          lang: friend.lang,
          name: friend.name,
          slug: friend.slug,
          alphabeticalName: friend.alphabeticalName,
          isCompilations: friend.isCompilations
        )
      )
    }
  }
}
