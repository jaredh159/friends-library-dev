import DuetSQL
import Vapor

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
