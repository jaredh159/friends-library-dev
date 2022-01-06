import Vapor

// below auto-generated

extension Resolver {
  func getRelatedDocument(req: Req, args: IdentifyEntityArgs) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .queryDocuments)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      throw Abort(.notImplemented, reason: "resolver.getRelatedDocument")
    }
  }

  func getRelatedDocuments(req: Req, args: NoArgs) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .queryDocuments)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      throw Abort(.notImplemented, reason: "resolver.getRelatedDocuments")
    }
  }

  func createRelatedDocument(
    req: Req,
    args: AppSchema.CreateRelatedDocumentArgs
  ) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateDocuments)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      throw Abort(.notImplemented, reason: "resolver.createRelatedDocument")
    }
  }

  func createRelatedDocuments(
    req: Req,
    args: AppSchema.CreateRelatedDocumentsArgs
  ) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .mutateDocuments)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      throw Abort(.notImplemented, reason: "resolver.createRelatedDocuments")
    }
  }

  func updateRelatedDocument(
    req: Req,
    args: AppSchema.UpdateRelatedDocumentArgs
  ) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateDocuments)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      throw Abort(.notImplemented, reason: "resolver.updateRelatedDocument")
    }
  }

  func updateRelatedDocuments(
    req: Req,
    args: AppSchema.UpdateRelatedDocumentsArgs
  ) throws -> Future<[RelatedDocument]> {
    try req.requirePermission(to: .mutateDocuments)
    return future(of: [RelatedDocument].self, on: req.eventLoop) {
      throw Abort(.notImplemented, reason: "resolver.updateRelatedDocuments")
    }
  }

  func deleteRelatedDocument(
    req: Req,
    args: IdentifyEntityArgs
  ) throws -> Future<RelatedDocument> {
    try req.requirePermission(to: .mutateDocuments)
    return future(of: RelatedDocument.self, on: req.eventLoop) {
      throw Abort(.notImplemented, reason: "resolver.deleteRelatedDocument")
    }
  }
}
