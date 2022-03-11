import Vapor

// below auto-generated

extension Resolver {
  func getDocumentTag(req: Req, args: IdentifyEntityArgs) throws -> Future<DocumentTag> {
    try req.requirePermission(to: .queryEntities)
    return future(of: DocumentTag.self, on: req.eventLoop) {
      try await Current.db.find(DocumentTag.self, byId: args.id)
    }
  }

  func getDocumentTags(req: Req, args: NoArgs) throws -> Future<[DocumentTag]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [DocumentTag].self, on: req.eventLoop) {
      try await Current.db.query(DocumentTag.self).all()
    }
  }

  func createDocumentTag(
    req: Req,
    args: InputArgs<AppSchema.CreateDocumentTagInput>
  ) throws -> Future<DocumentTag> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: DocumentTag.self, on: req.eventLoop) {
      let documentTag = DocumentTag(args.input)
      guard documentTag.isValid else { throw DbError.invalidEntity }
      let created = try await Current.db.create(documentTag)
      return try await Current.db.find(created.id)
    }
  }

  func createDocumentTags(
    req: Req,
    args: InputArgs<[AppSchema.CreateDocumentTagInput]>
  ) throws -> Future<[DocumentTag]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [DocumentTag].self, on: req.eventLoop) {
      let documentTags = args.input.map(DocumentTag.init)
      guard documentTags.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.create(documentTags)
      return try await Current.db.query(DocumentTag.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func updateDocumentTag(
    req: Req,
    args: InputArgs<AppSchema.UpdateDocumentTagInput>
  ) throws -> Future<DocumentTag> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: DocumentTag.self, on: req.eventLoop) {
      let documentTag = DocumentTag(args.input)
      guard documentTag.isValid else { throw DbError.invalidEntity }
      try await Current.db.update(documentTag)
      return try await Current.db.find(documentTag.id)
    }
  }

  func updateDocumentTags(
    req: Req,
    args: InputArgs<[AppSchema.UpdateDocumentTagInput]>
  ) throws -> Future<[DocumentTag]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [DocumentTag].self, on: req.eventLoop) {
      let documentTags = args.input.map(DocumentTag.init)
      guard documentTags.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.update(documentTags)
      return try await Current.db.query(DocumentTag.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func deleteDocumentTag(req: Req, args: IdentifyEntityArgs) throws -> Future<DocumentTag> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: DocumentTag.self, on: req.eventLoop) {
      try await Current.db.delete(DocumentTag.self, byId: args.id)
    }
  }
}
