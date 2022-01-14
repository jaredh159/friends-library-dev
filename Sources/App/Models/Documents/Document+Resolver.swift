import Vapor

// below auto-generated

extension Resolver {
  func getDocument(req: Req, args: IdentifyEntityArgs) throws -> Future<Document> {
    try req.requirePermission(to: .queryFriends)
    return future(of: Document.self, on: req.eventLoop) {
      try await Current.db.find(Document.self, byId: args.id)
    }
  }

  func getDocuments(req: Req, args: NoArgs) throws -> Future<[Document]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [Document].self, on: req.eventLoop) {
      try await Current.db.query(Document.self).all()
    }
  }

  func createDocument(
    req: Req,
    args: AppSchema.CreateDocumentArgs
  ) throws -> Future<Document> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Document.self, on: req.eventLoop) {
      try await Current.db.create(Document(args.input))
    }
  }

  func createDocuments(
    req: Req,
    args: AppSchema.CreateDocumentsArgs
  ) throws -> Future<[Document]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Document].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(Document.init))
    }
  }

  func updateDocument(
    req: Req,
    args: AppSchema.UpdateDocumentArgs
  ) throws -> Future<Document> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Document.self, on: req.eventLoop) {
      try await Current.db.update(Document(args.input))
    }
  }

  func updateDocuments(
    req: Req,
    args: AppSchema.UpdateDocumentsArgs
  ) throws -> Future<[Document]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [Document].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(Document.init))
    }
  }

  func deleteDocument(req: Req, args: IdentifyEntityArgs) throws -> Future<Document> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: Document.self, on: req.eventLoop) {
      try await Current.db.delete(Document.self, byId: args.id)
    }
  }
}
