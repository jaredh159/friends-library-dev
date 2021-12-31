// auto-generated, do not edit
@testable import App

extension Friend {
  static var mock: Friend {
    Friend(
      lang: .en,
      name: "@mock name",
      slug: "@mock slug",
      gender: .male,
      description: "@mock description",
      born: nil,
      died: nil,
      published: nil
    )
  }

  static var empty: Friend {
    Friend(
      lang: .en,
      name: "",
      slug: "",
      gender: .male,
      description: "",
      born: nil,
      died: nil,
      published: nil
    )
  }

  static var random: Friend {
    Friend(
      lang: Lang.allCases.shuffled().first!,
      name: "@random".random,
      slug: "@random".random,
      gender: Gender.allCases.shuffled().first!,
      description: "@random".random,
      born: nil,
      died: nil,
      published: nil
    )
  }
}
