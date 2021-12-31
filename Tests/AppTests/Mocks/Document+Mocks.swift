// auto-generated, do not edit
@testable import App

extension Document {
  static var mock: Document {
    Document(
      friendId: .init(),
      altLanguageId: nil,
      title: "@mock title",
      slug: "@mock slug",
      filename: "@mock filename",
      published: nil,
      originalTitle: nil,
      incomplete: true,
      description: "@mock description",
      partialDescription: "@mock partialDescription",
      featuredDescription: nil
    )
  }

  static var empty: Document {
    Document(
      friendId: .init(),
      altLanguageId: nil,
      title: "",
      slug: "",
      filename: "",
      published: nil,
      originalTitle: nil,
      incomplete: false,
      description: "",
      partialDescription: "",
      featuredDescription: nil
    )
  }

  static var random: Document {
    Document(
      friendId: .init(),
      altLanguageId: nil,
      title: "@random".random,
      slug: "@random".random,
      filename: "@random".random,
      published: nil,
      originalTitle: nil,
      incomplete: Bool.random(),
      description: "@random".random,
      partialDescription: "@random".random,
      featuredDescription: nil
    )
  }
}
