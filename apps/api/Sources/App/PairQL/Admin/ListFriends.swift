import PairQL

struct ListFriends: Pair {
  static var auth: Scope = .queryEntities

  struct FriendOutput: PairOutput {
    let id: Friend.Id
    let name: String
    let alphabeticalName: String
    let lang: Lang
  }

  typealias Output = [FriendOutput]
}

extension ListFriends: NoInputResolver {
  static func resolve(in context: AuthedContext) async throws -> Output {
    try context.verify(Self.auth)
    let friends = try await Friend.query().all()
    return friends.map { friend in
      .init(
        id: friend.id,
        name: friend.name,
        alphabeticalName: friend.alphabeticalName,
        lang: friend.lang
      )
    }
  }
}
