import Vapor

// below auto-generated

extension Resolver {
  func getRelatedDocument(req: Req, args: IdentifyEntityArgs) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .queryEntities)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      try await Current.db.find(RelatedDocument.self, byId: args.id)
    }
  }

  func getRelatedDocuments(req: Req, args: NoArgs) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .queryEntities)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      try await Current.db.query(RelatedDocument.self).all()
    }
  }

  func createRelatedDocument(
    req: Req,
    args: InputArgs<AppSchema.CreateRelatedDocumentInput>
  ) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      let relatedDocument = RelatedDocument(args.input)
      guard relatedDocument.isValid else { throw DbError.invalidEntity }
      let created = try await Current.db.create(relatedDocument)
      return try await Current.db.find(created.id)
    }
  }

  func createRelatedDocuments(
    req: Req,
    args: InputArgs<[AppSchema.CreateRelatedDocumentInput]>
  ) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      let relatedDocuments = args.input.map(RelatedDocument.init)
      guard relatedDocuments.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.create(relatedDocuments)
      return try await Current.db.query(RelatedDocument.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func updateRelatedDocument(
    req: Req,
    args: InputArgs<AppSchema.UpdateRelatedDocumentInput>
  ) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      let relatedDocument = RelatedDocument(args.input)
      guard relatedDocument.isValid else { throw DbError.invalidEntity }
      try await Current.db.update(relatedDocument)
      return try await Current.db.find(relatedDocument.id)
    }
  }

  func updateRelatedDocuments(
    req: Req,
    args: InputArgs<[AppSchema.UpdateRelatedDocumentInput]>
  ) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      let relatedDocuments = args.input.map(RelatedDocument.init)
      guard relatedDocuments.allSatisfy(\.isValid) else { throw DbError.invalidEntity }
      let created = try await Current.db.update(relatedDocuments)
      return try await Current.db.query(RelatedDocument.self)
        .where(.id |=| created.map(\.id))
        .all()
    }
  }

  func deleteRelatedDocument(req: Req, args: IdentifyEntityArgs) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateEntities)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      try await Current.db.delete(RelatedDocument.self, byId: args.id)
    }
  }
}
