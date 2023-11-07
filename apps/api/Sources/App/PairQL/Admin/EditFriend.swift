import Foundation
import PairQL

struct EditFriend: Pair {
  static var auth: Scope = .queryEntities

  typealias Input = Friend.Id

  struct FriendOutput: PairNestable {
    struct Quote: PairNestable {
      let id: FriendQuote.Id
      let source: String
      let text: String
      let order: Int
      // had a ref to friend->id
    }

    struct Residence: PairNestable {
      struct Duration: PairNestable {
        let id: FriendResidenceDuration.Id
        let start: Int
        let end: Int
        // had a ref to residence->id
      }

      let id: FriendResidence.Id
      let city: String
      let region: String
      let durations: [Duration]
      // had a ref to friend->id
    }

    let id: Friend.Id
    let lang: Lang
    let name: String
    let slug: String
    let gender: Friend.Gender
    let born: Int?
    let died: Int?
    let description: String
    let published: Date?
    let residences: [Residence]
    let quotes: [Quote]
    let documents: [EditDocument.EditDocumentOutput]
  }

  struct Output: PairOutput {
    let friend: FriendOutput
    let selectableDocuments: [SelectableDocuments.SelectableDocument]
  }
}

extension EditFriend: PairQL.Resolver {
  static func resolve(with input: Input, in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let friend = try await Friend.find(input)
    async let documents = friend.documents()
    async let residences = friend.residences()
    async let quotes = friend.quotes()
    return .init(
      friend: .init(
        id: friend.id,
        lang: friend.lang,
        name: friend.name,
        slug: friend.slug,
        gender: friend.gender,
        born: friend.born,
        died: friend.died,
        description: friend.description,
        published: friend.published,
        residences: try await residences.concurrentMap { residence in
          let durations = try await residence.durations()
          return .init(
            id: residence.id,
            city: residence.city,
            region: residence.region,
            durations: durations.map { .init(id: $0.id, start: $0.start, end: $0.end) }
          )
        },
        quotes: try await quotes.map {
          .init(id: $0.id, source: $0.source, text: $0.text, order: $0.order)
        },
        documents: try await documents.concurrentMap { try await .init(model: $0) }
      ),
      selectableDocuments: try await .load()
    )
  }
}
