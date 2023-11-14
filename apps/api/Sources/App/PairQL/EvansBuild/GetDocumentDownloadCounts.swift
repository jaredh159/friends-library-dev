import PairQL

struct GetDocumentDownloadCounts: Pair {
  static var auth: Scope = .queryEntities

  struct DocumentDownloadCount: PairOutput {
    var documentId: Document.Id
    var downloadCount: Int
  }

  typealias Output = [DocumentDownloadCount]
}

extension GetDocumentDownloadCounts: NoInputResolver {
  static func resolve(in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
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
