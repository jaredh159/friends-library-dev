@testable import App

extension DocumentTag {
  static var mock: DocumentTag {
    DocumentTag(documentId: .init(), type: .journal)
  }

  static var empty: DocumentTag {
    DocumentTag(documentId: .init(), type: .journal)
  }

  static var random: DocumentTag {
    DocumentTag(documentId: .init(), type: TagType.allCases.shuffled().first!)
  }
}
