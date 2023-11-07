import PairQL
import TaggedTime

struct EditDocument: Pair {
  static var auth: Scope = .queryEntities

  typealias Input = Document.Id

  struct EditEdition: PairNestable {
    let id: Edition.Id
    let type: EditionType
    let paperbackSplits: [Int]?
    let paperbackOverrideSize: PrintSizeVariant?
    let editor: String?
    let isbn: String?
    let isDraft: Bool
    let audio: EditAudio?
    // had a ref to -> document.id
  }

  struct EditAudio: PairNestable {
    let id: Audio.Id
    let reader: String
    let isIncomplete: Bool
    let mp3ZipSizeHq: Bytes
    let mp3ZipSizeLq: Bytes
    let m4bSizeHq: Bytes
    let m4bSizeLq: Bytes
    let externalPlaylistIdHq: Audio.ExternalPlaylistId?
    let externalPlaylistIdLq: Audio.ExternalPlaylistId?
    let parts: [EditAudioPart]
    // had a ref to -> edition.id
  }

  struct EditAudioPart: PairNestable {
    let id: AudioPart.Id
    let order: Int
    let title: String
    let duration: Seconds<Double>
    let chapters: [Int]
    let mp3SizeHq: Bytes
    let mp3SizeLq: Bytes
    let externalIdHq: AudioPart.ExternalId
    let externalIdLq: AudioPart.ExternalId
    // had a ref to -> audio.id
  }

  struct EditDocumentOutput: PairNestable {
    struct FriendOutput: PairNestable {
      let id: Friend.Id
      let name: String
      let lang: Lang
    }

    struct TagOutput: PairNestable {
      let id: DocumentTag.Id
      let type: DocumentTag.TagType
      // had a ref to -> document.id
    }

    struct RelatedDocumentOutput: PairNestable {
      let id: Document.Id
      let description: String
      let parentDocumentId: Document.Id
    }

    let id: Document.Id
    let altLanguageId: Document.Id?
    let title: String
    let slug: String
    let filename: String
    let published: Int?
    let originalTitle: String?
    let incomplete: Bool
    let description: String
    let partialDescription: String
    let featuredDescription: String?
    let friend: FriendOutput
    let editions: [EditEdition]
    let tags: [TagOutput]
    let relatedDocuments: [RelatedDocumentOutput]
  }

  struct Output: PairOutput {
    let document: EditDocumentOutput
    let selectableDocuments: [SelectableDocuments.SelectableDocument]
  }
}

// resolver

extension EditDocument: PairQL.Resolver {
  static func resolve(with input: Input, in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let document = try await Document.find(input)
    return try await .init(
      document: .init(model: document),
      selectableDocuments: .load()
    )
  }
}

// extensions

extension EditDocument.EditDocumentOutput {
  init(model document: Document) async throws {
    async let friend = document.friend()
    async let editions = document.editions()
    async let tags = document.tags()
    async let relatedDocuments = document.relatedDocuments()

    id = document.id
    altLanguageId = document.altLanguageId
    title = document.title
    slug = document.slug
    filename = document.filename
    published = document.published
    originalTitle = document.originalTitle
    incomplete = document.incomplete
    description = document.description
    partialDescription = document.partialDescription
    featuredDescription = document.featuredDescription

    self.friend = .init(
      id: try await friend.id,
      name: try await friend.name,
      lang: try await friend.lang
    )

    self.editions = try await editions.concurrentMap { edition in
      async let isbn = edition.isbn()
      async let audio = edition.audio()
      var audioOutput: EditDocument.EditAudio?
      if let audio = try await audio {
        let parts = try await audio.parts()
        audioOutput = .init(
          id: audio.id,
          reader: audio.reader,
          isIncomplete: audio.isIncomplete,
          mp3ZipSizeHq: audio.mp3ZipSizeHq,
          mp3ZipSizeLq: audio.mp3ZipSizeLq,
          m4bSizeHq: audio.m4bSizeHq,
          m4bSizeLq: audio.m4bSizeLq,
          externalPlaylistIdHq: audio.externalPlaylistIdHq,
          externalPlaylistIdLq: audio.externalPlaylistIdLq,
          parts: parts.map { part in
            .init(
              id: part.id,
              order: part.order,
              title: part.title,
              duration: part.duration,
              chapters: Array(part.chapters),
              mp3SizeHq: part.mp3SizeHq,
              mp3SizeLq: part.mp3SizeLq,
              externalIdHq: part.externalIdHq,
              externalIdLq: part.externalIdLq
            )
          }
        )
      }
      return .init(
        id: edition.id,
        type: edition.type,
        paperbackSplits: edition.paperbackSplits.map { Array($0) },
        paperbackOverrideSize: edition.paperbackOverrideSize,
        editor: edition.editor,
        isbn: try await isbn?.code.rawValue,
        isDraft: edition.isDraft,
        audio: audioOutput
      )
    }

    self.tags = try await tags.map { .init(id: $0.id, type: $0.type) }
    self.relatedDocuments = try await relatedDocuments.map { doc in
      .init(
        id: doc.documentId,
        description: doc.description,
        parentDocumentId: doc.parentDocumentId
      )
    }
  }
}
