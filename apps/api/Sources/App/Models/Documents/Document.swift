import DuetSQL

final class Document: Codable {
  var id: Id
  var friendId: Friend.Id
  var altLanguageId: Id?
  var title: String
  var slug: String
  var filename: String
  var published: Int?
  var originalTitle: String?
  var incomplete: Bool // e.g. spanish books that are available before completely translated
  var description: String
  var partialDescription: String
  var featuredDescription: String?
  var createdAt = Current.date()
  var updatedAt = Current.date()
  var deletedAt: Date? = nil

  var friend = Parent<Friend>.notLoaded
  var editions = Children<Edition>.notLoaded
  var altLanguageDocument = OptionalParent<Document>.notLoaded
  var relatedDocuments = Children<RelatedDocument>.notLoaded
  var tags = Children<DocumentTag>.notLoaded

  var lang: Lang {
    friend.require().lang
  }

  var primaryEdition: Edition? {
    let allEditions = editions.require()
    return allEditions.first { $0.type == .updated } ??
      allEditions.first { $0.type == .modernized } ??
      allEditions.first
  }

  var hasNonDraftEdition: Bool {
    editions.require().first { $0.isDraft == false } != nil
  }

  var directoryPath: String {
    "\(friend.require().directoryPath)/\(slug)"
  }

  var htmlTitle: String {
    Asciidoc.htmlTitle(title)
  }

  var htmlShortTitle: String {
    Asciidoc.htmlShortTitle(title)
  }

  var utf8ShortTitle: String {
    Asciidoc.utf8ShortTitle(title)
  }

  var trimmedUtf8ShortTitle: String {
    Asciidoc.trimmedUtf8ShortDocumentTitle(title, lang: friend.require().lang)
  }

  init(
    id: Id = .init(),
    friendId: Friend.Id,
    altLanguageId: Id?,
    title: String,
    slug: String,
    filename: String,
    published: Int?,
    originalTitle: String?,
    incomplete: Bool,
    description: String,
    partialDescription: String,
    featuredDescription: String?
  ) {
    self.id = id
    self.friendId = friendId
    self.slug = slug
    self.altLanguageId = altLanguageId
    self.title = title
    self.filename = filename
    self.published = published
    self.originalTitle = originalTitle
    self.incomplete = incomplete
    self.description = description
    self.partialDescription = partialDescription
    self.featuredDescription = featuredDescription
  }
}

// loaders

extension Document {
  func friend() async throws -> Friend {
    try await friend.useLoaded(or: {
      try await Friend.query()
        .where(.id == friendId)
        .first()
    })
  }

  func editions() async throws -> [Edition] {
    try await editions.useLoaded(or: {
      try await Edition.query()
        .where(.documentId == id)
        .all()
    })
  }

  func tags() async throws -> [DocumentTag] {
    try await tags.useLoaded(or: {
      try await DocumentTag.query()
        .where(.documentId == id)
        .all()
    })
  }

  func relatedDocuments() async throws -> [RelatedDocument] {
    try await relatedDocuments.useLoaded(or: {
      try await RelatedDocument.query()
        .where(.parentDocumentId == id)
        .all()
    })
  }

  func altLanguageDocument() async throws -> Document? {
    try await altLanguageDocument.useLoaded(or: {
      guard let altLanguageId = altLanguageId else { return nil }
      return try await Document.query()
        .where(.id == altLanguageId)
        .first()
    })
  }
}
