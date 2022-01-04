// auto-generated, do not edit
import Graphiti
import Vapor

extension AppSchema {
  static var DocumentType: AppType<Document> {
    Type(Document.self) {
      Field("id", at: \.id.rawValue)
      Field("friendId", at: \.friendId.rawValue)
      Field("altLanguageId", at: \.altLanguageId?.rawValue)
      Field("title", at: \.title)
      Field("slug", at: \.slug)
      Field("filename", at: \.filename)
      Field("published", at: \.published)
      Field("originalTitle", at: \.originalTitle)
      Field("incomplete", at: \.incomplete)
      Field("description", at: \.description)
      Field("partialDescription", at: \.partialDescription)
      Field("featuredDescription", at: \.featuredDescription)
      Field("createdAt", at: \.createdAt)
      Field("updatedAt", at: \.updatedAt)
      Field("friend", with: \.friend)
      Field("altLanguageDocument", with: \.altLanguageDocument)
      Field("relatedDocuments", with: \.relatedDocuments)
    }
  }

  struct CreateDocumentInput: Codable {
    let id: UUID?
    let friendId: UUID
    let altLanguageId: UUID?
    let title: String
    let slug: String
    let filename: String
    let published: Int?
    let originalTitle: String?
    let incomplete: Bool
    let description: String
    let partialDescription: String
    let featuredDescription: String?
  }

  struct UpdateDocumentInput: Codable {
    let id: UUID
    let friendId: UUID
    let altLanguageId: UUID?
    let title: String
    let slug: String
    let filename: String
    let published: Int?
    let originalTitle: String?
    let incomplete: Bool
    let description: String
    let partialDescription: String
    let featuredDescription: String?
  }

  struct CreateDocumentArgs: Codable {
    let input: AppSchema.CreateDocumentInput
  }

  struct UpdateDocumentArgs: Codable {
    let input: AppSchema.UpdateDocumentInput
  }

  struct CreateDocumentsArgs: Codable {
    let input: [AppSchema.CreateDocumentInput]
  }

  struct UpdateDocumentsArgs: Codable {
    let input: [AppSchema.UpdateDocumentInput]
  }

  static var CreateDocumentInputType: AppInput<AppSchema.CreateDocumentInput> {
    Input(AppSchema.CreateDocumentInput.self) {
      InputField("id", at: \.id)
      InputField("friendId", at: \.friendId)
      InputField("altLanguageId", at: \.altLanguageId)
      InputField("title", at: \.title)
      InputField("slug", at: \.slug)
      InputField("filename", at: \.filename)
      InputField("published", at: \.published)
      InputField("originalTitle", at: \.originalTitle)
      InputField("incomplete", at: \.incomplete)
      InputField("description", at: \.description)
      InputField("partialDescription", at: \.partialDescription)
      InputField("featuredDescription", at: \.featuredDescription)
    }
  }

  static var UpdateDocumentInputType: AppInput<AppSchema.UpdateDocumentInput> {
    Input(AppSchema.UpdateDocumentInput.self) {
      InputField("id", at: \.id)
      InputField("friendId", at: \.friendId)
      InputField("altLanguageId", at: \.altLanguageId)
      InputField("title", at: \.title)
      InputField("slug", at: \.slug)
      InputField("filename", at: \.filename)
      InputField("published", at: \.published)
      InputField("originalTitle", at: \.originalTitle)
      InputField("incomplete", at: \.incomplete)
      InputField("description", at: \.description)
      InputField("partialDescription", at: \.partialDescription)
      InputField("featuredDescription", at: \.featuredDescription)
    }
  }

  static var getDocument: AppField<Document, IdentifyEntityArgs> {
    Field("getDocument", at: Resolver.getDocument) {
      Argument("id", at: \.id)
    }
  }

  static var getDocuments: AppField<[Document], NoArgs> {
    Field("getDocuments", at: Resolver.getDocuments)
  }

  static var createDocument: AppField<Document, AppSchema.CreateDocumentArgs> {
    Field("createDocument", at: Resolver.createDocument) {
      Argument("input", at: \.input)
    }
  }

  static var createDocuments: AppField<[Document], AppSchema.CreateDocumentsArgs> {
    Field("createDocuments", at: Resolver.createDocuments) {
      Argument("input", at: \.input)
    }
  }

  static var updateDocument: AppField<Document, AppSchema.UpdateDocumentArgs> {
    Field("updateDocument", at: Resolver.updateDocument) {
      Argument("input", at: \.input)
    }
  }

  static var updateDocuments: AppField<[Document], AppSchema.UpdateDocumentsArgs> {
    Field("updateDocuments", at: Resolver.updateDocuments) {
      Argument("input", at: \.input)
    }
  }

  static var deleteDocument: AppField<Document, IdentifyEntityArgs> {
    Field("deleteDocument", at: Resolver.deleteDocument) {
      Argument("id", at: \.id)
    }
  }
}

extension Document {
  convenience init(_ input: AppSchema.CreateDocumentInput) {
    self.init(
      id: .init(rawValue: input.id ?? UUID()),
      friendId: .init(rawValue: input.friendId),
      altLanguageId: input.altLanguageId != nil ? .init(rawValue: input.altLanguageId!) : nil,
      title: input.title,
      slug: input.slug,
      filename: input.filename,
      published: input.published,
      originalTitle: input.originalTitle,
      incomplete: input.incomplete,
      description: input.description,
      partialDescription: input.partialDescription,
      featuredDescription: input.featuredDescription
    )
  }

  convenience init(_ input: AppSchema.UpdateDocumentInput) {
    self.init(
      id: .init(rawValue: input.id),
      friendId: .init(rawValue: input.friendId),
      altLanguageId: input.altLanguageId != nil ? .init(rawValue: input.altLanguageId!) : nil,
      title: input.title,
      slug: input.slug,
      filename: input.filename,
      published: input.published,
      originalTitle: input.originalTitle,
      incomplete: input.incomplete,
      description: input.description,
      partialDescription: input.partialDescription,
      featuredDescription: input.featuredDescription
    )
  }

  func update(_ input: AppSchema.UpdateDocumentInput) {
    self.friendId = .init(rawValue: input.friendId)
    self.altLanguageId = input.altLanguageId != nil ? .init(rawValue: input.altLanguageId!) : nil
    self.title = input.title
    self.slug = input.slug
    self.filename = input.filename
    self.published = input.published
    self.originalTitle = input.originalTitle
    self.incomplete = input.incomplete
    self.description = input.description
    self.partialDescription = input.partialDescription
    self.featuredDescription = input.featuredDescription
    self.updatedAt = Current.date()
  }
}
