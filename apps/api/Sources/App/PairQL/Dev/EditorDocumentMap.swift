import PairQL

struct EditorDocumentMap: Pair {
  static var auth: Scope = .queryEntities
  // [directoryPath: trimmedUtf8ShortTitle]
  typealias Output = [String: String]
}

extension EditorDocumentMap: NoInputResolver {
  static func resolve(in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let documents = try await Document.query().all()
    return documents.reduce(into: [:]) { acc, document in
      acc[document.directoryPath] = document.trimmedUtf8ShortTitle
    }
  }
}
