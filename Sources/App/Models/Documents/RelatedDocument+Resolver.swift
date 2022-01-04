import Vapor

// below auto-generated

extension Resolver {
  func getRelatedDocument(req: Req, args: IdentifyEntityArgs) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .queryDocuments)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      try await Current.db.getRelatedDocument(.init(rawValue: args.id))
    }
  }

  func getRelatedDocuments(req: Req, args: NoArgs) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .queryDocuments)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      try await Current.db.getRelatedDocuments()
    }
  }

  func createRelatedDocument(
    req: Req,
    args: AppSchema.CreateRelatedDocumentArgs
  ) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateDocuments)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      try await Current.db.createRelatedDocument(RelatedDocument(args.input))
    }
  }

  func createRelatedDocuments(
    req: Req,
    args: AppSchema.CreateRelatedDocumentsArgs
  ) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .mutateDocuments)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      try await Current.db.createRelatedDocuments(args.input.map(RelatedDocument.init))
    }
  }

  func updateRelatedDocument(
    req: Req,
    args: AppSchema.UpdateRelatedDocumentArgs
  ) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateDocuments)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      try await Current.db.updateRelatedDocument(RelatedDocument(args.input))
    }
  }

  func updateRelatedDocuments(
    req: Req,
    args: AppSchema.UpdateRelatedDocumentsArgs
  ) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .mutateDocuments)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      try await Current.db.updateRelatedDocuments(args.input.map(RelatedDocument.init))
    }
  }

  func deleteRelatedDocument(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateDocuments)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      try await Current.db.deleteRelatedDocument(.init(rawValue: args.id))
    }
  }
}
