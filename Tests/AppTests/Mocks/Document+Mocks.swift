// auto-generated, do not edit
import GraphQL

@testable import App

extension App.Document {
  static var mock: App.Document {
    Document(
      friendId: .init(),
      altLanguageId: nil,
      title: "@mock title",
      slug: "mock-slug-slug",
      filename: "@mock filename",
      published: nil,
      originalTitle: nil,
      incomplete: true,
      description: "@mock description",
      partialDescription: "@mock partialDescription",
      featuredDescription: nil
    )
  }

  static var empty: App.Document {
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

  static var random: App.Document {
    Document(
      friendId: .init(),
      altLanguageId: Bool.random() ? .init(rawValue: .init()) : nil,
      title: "@random".random,
      slug: "random-slug-\(Int.random)",
      filename: "@random".random,
      published: Bool.random() ? Int.random : nil,
      originalTitle: Bool.random() ? "@random".random : nil,
      incomplete: Bool.random(),
      description: "@random".random,
      partialDescription: "@random".random,
      featuredDescription: Bool.random() ? "@random".random : nil
    )
  }

  func gqlMap(omitting: Set<String> = []) -> GraphQL.Map {
    var map: GraphQL.Map = .dictionary([
      "id": .string(id.rawValue.uuidString),
      "friendId": .string(friendId.rawValue.uuidString),
      "altLanguageId": altLanguageId != nil ? .string(altLanguageId!.rawValue.uuidString) : .null,
      "title": .string(title),
      "slug": .string(slug),
      "filename": .string(filename),
      "published": published != nil ? .number(Number(published!)) : .null,
      "originalTitle": originalTitle != nil ? .string(originalTitle!) : .null,
      "incomplete": .bool(incomplete),
      "description": .string(description),
      "partialDescription": .string(partialDescription),
      "featuredDescription": featuredDescription != nil ? .string(featuredDescription!) : .null,
    ])
    omitting.forEach { try? map.remove($0) }
    return map
  }
}
