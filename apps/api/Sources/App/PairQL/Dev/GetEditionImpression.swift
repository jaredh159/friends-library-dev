import PairQL

struct GetEditionImpression: Pair {
  static var auth: Scope = .queryEntities

  typealias Input = EditionImpression.Id

  struct Output: PairOutput {
    struct Files: PairNestable {
      var paperbackCover: [String]
      var paperbackInterior: [String]
      var epub: String
      var mobi: String
      var pdf: String
      var speech: String
      var app: String
    }

    let id: EditionImpression.Id
    let cloudFiles: Files
  }
}

extension GetEditionImpression: PairQL.Resolver {
  static func resolve(with input: Input, in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let impression = try await EditionImpression.find(input)
    return .init(id: impression.id, cloudFiles: .init(model: impression))
  }
}

extension GetEditionImpression.Output.Files {
  init(model impression: EditionImpression) {
    self = .init(
      paperbackCover: impression.files.paperback.cover.map(\.sourcePath),
      paperbackInterior: impression.files.paperback.interior.map(\.sourcePath),
      epub: impression.files.ebook.epub.sourcePath,
      mobi: impression.files.ebook.mobi.sourcePath,
      pdf: impression.files.ebook.pdf.sourcePath,
      speech: impression.files.ebook.speech.sourcePath,
      app: impression.files.ebook.app.sourcePath
    )
  }
}
