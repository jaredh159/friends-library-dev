import Vapor

// below auto-generated

extension Resolver {
  func getRelatedDocument(req: Req, args: IdentifyEntityArgs) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .queryFriends)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      try await Current.db.find(RelatedDocument.self, byId: args.id)
    }
  }

  func getRelatedDocuments(req: Req, args: NoArgs) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .queryFriends)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      try await Current.db.query(RelatedDocument.self).all()
    }
  }

  func createRelatedDocument(
    req: Req,
    args: AppSchema.CreateRelatedDocumentArgs
  ) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      try await Current.db.create(RelatedDocument(args.input))
    }
  }

  func createRelatedDocuments(
    req: Req,
    args: AppSchema.CreateRelatedDocumentsArgs
  ) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      try await Current.db.create(args.input.map(RelatedDocument.init))
    }
  }

  func updateRelatedDocument(
    req: Req,
    args: AppSchema.UpdateRelatedDocumentArgs
  ) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      try await Current.db.update(RelatedDocument(args.input))
    }
  }

  func updateRelatedDocuments(
    req: Req,
    args: AppSchema.UpdateRelatedDocumentsArgs
  ) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      try await Current.db.update(args.input.map(RelatedDocument.init))
    }
  }

  func deleteRelatedDocument(req: Req, args: IdentifyEntityArgs) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateFriends)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      try await Current.db.delete(RelatedDocument.self, byId: args.id)
    }
  }
}
