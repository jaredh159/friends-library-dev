import Vapor

extension Resolver {

  func createDocument(req: Req, args: AppSchema.CreateDocumentArgs) throws -> Future<Document> {
    try req.requirePermission(to: .mutateDocuments)
    return future(of: Document.self, on: req.eventLoop) {
      let document = Document(args.input)
      try await Current.db.createDocument(document)
      return document
    }
  }

  func getDocument(req: Req, args: IdentifyEntityArgs) throws -> Future<Document> {
    try req.requirePermission(to: .queryDocuments)
    return future(of: Document.self, on: req.eventLoop) {
      try await Current.db.getDocument(.init(rawValue: args.id))
    }
  }

  func updateDocument(req: Req, args: AppSchema.UpdateDocumentArgs) throws -> Future<Document> {
    try req.requirePermission(to: .mutateDocuments)
    return future(of: Document.self, on: req.eventLoop) {
      try await Current.db.updateDocument(Document(args.input))
    }
  }

  func deleteDocument(req: Req, args: IdentifyEntityArgs) throws -> Future<Document> {
    try req.requirePermission(to: .mutateDocuments)
    return future(of: Document.self, on: req.eventLoop) {
      let document = try await Current.db.getDocument(.init(rawValue: args.id))
      try await Current.db.deleteDocument(document.id)
      return document
    }
  }
}

// below auto-generated

extension Resolver {

  func getDocuments(req: Req, args: NoArgs) throws -> Future<[Document]> {
    throw Abort(.notImplemented, reason: "Resolver.getDocuments")
  }

  func createDocuments(req: Req, args: AppSchema.CreateDocumentsArgs) throws -> Future<[Document]> {
    throw Abort(.notImplemented, reason: "Resolver.createDocuments")
  }

  func updateDocuments(req: Req, args: AppSchema.UpdateDocumentsArgs) throws -> Future<[Document]> {
    throw Abort(.notImplemented, reason: "Resolver.updateDocuments")
  }
}
