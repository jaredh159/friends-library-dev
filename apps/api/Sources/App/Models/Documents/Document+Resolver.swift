import DuetSQL
import Graphiti
import Vapor

struct DocumentDownloadCount: Encodable {
  var documentId: Document.Id
  var downloadCount: Int
}

extension AppSchema {
  static var getDocumentDownloadCounts: AppField<[DocumentDownloadCount], NoArgs> {
    Field("getDocumentDownloadCounts", at: Resolver.getDocumentDownloadCounts)
  }

  static var DocumentDownloadCountType: AppType<DocumentDownloadCount> {
    Type(DocumentDownloadCount.self) {
      Field("documentId", at: \.documentId.lowercased)
      Field("downloadCount", at: \.downloadCount)
    }
  }
}

extension Resolver {
  func getDocumentDownloadCounts(
    req: Req,
    args: NoArgs
  ) throws -> Future<[DocumentDownloadCount]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [DocumentDownloadCount].self, on: req.eventLoop) {
      let editionModels = try await Current.db.query(Edition.self).all()
      let editions = editionModels.reduce(into: [:]) { $0[$1.id] = $1 }
      var documents: [Document.Id: DocumentDownloadCount] = [:]
      let downloads = try await Current.db.query(Download.self).all()
      for download in downloads {
        if let documentId = editions[download.editionId]?.documentId {
          if var document = documents[documentId] {
            document.downloadCount += 1
            documents[documentId] = document
          } else {
            documents[documentId] = DocumentDownloadCount(
              documentId: documentId,
              downloadCount: 1
            )
          }
        }
      }
      return Array(documents.values)
    }
  }
}

// below auto-generated

extension Resolver {
  func getDocument(req: Req, args: IdentifyEntityArgs) throws -> Future<Document> {
    try req.requirePermission(to: .queryEntities)
    return future(of: Document.self, on: req.eventLoop) {
      try await Current.db.find(Document.self, byId: args.id)
    }
  }

  func getDocuments(req: Req, args: NoArgs) throws -> Future<[Document]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [Document].self, on: req.eventLoop) {
      try await Current.db.query(Document.self).all()
    }
  }

  func createDocument(
    req: Req,
    args: InputArgs<AppSchema.CreateDocumentInput>
  ) throws -> Future<Document> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Document.self, on: req.eventLoop) {
      let document = Document(args.input)
      guard document.isValid else { throw ModelError.invalidEntity }
      let created = try await Current.db.create(document)
      return try await Current.db.find(created.id)
    }
  }

  func createDocuments(
    req: Req,
    args: InputArgs<[AppSchema.CreateDocumentInput]>
  ) throws -> Future<[Document]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Document].self, on: req.eventLoop) {
      let documents = args.input.map(Document.init)
      guard documents.allSatisfy(\.isValid) else { throw ModelError.invalidEntity }
      let created = try await Current.db.create(documents)
      return try await Current.db.query(Document.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func updateDocument(
    req: Req,
    args: InputArgs<AppSchema.UpdateDocumentInput>
  ) throws -> Future<Document> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Document.self, on: req.eventLoop) {
      let document = Document(args.input)
      guard document.isValid else { throw ModelError.invalidEntity }
      try await Current.db.update(document)
      return try await Current.db.find(document.id)
    }
  }

  func updateDocuments(
    req: Req,
    args: InputArgs<[AppSchema.UpdateDocumentInput]>
  ) throws -> Future<[Document]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [Document].self, on: req.eventLoop) {
      let documents = args.input.map(Document.init)
      guard documents.allSatisfy(\.isValid) else { throw ModelError.invalidEntity }
      let created = try await Current.db.update(documents)
      return try await Current.db.query(Document.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func deleteDocument(req: Req, args: IdentifyEntityArgs) throws -> Future<Document> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: Document.self, on: req.eventLoop) {
      try await Current.db.delete(Document.self, byId: args.id)
    }
  }
}
