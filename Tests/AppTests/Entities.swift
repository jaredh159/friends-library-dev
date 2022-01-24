@testable import App

struct Entities {
  var friend: Friend
  var friendResidence: FriendResidence
  var friendResidenceDuration: FriendResidenceDuration
  var friendQuote: FriendQuote
  var document: Document
  var documentTag: DocumentTag
  var edition: Edition
  var editionChapter: EditionChapter
  var editionImpression: EditionImpression
  var isbn: Isbn
  var audio: Audio
  var audioPart: AudioPart

  static func create(beforePersist: (inout Entities) -> Void = { _ in }) async -> Entities {
    let friend: Friend = .random

    let friendResidence: FriendResidence = .random
    friendResidence.friendId = friend.id
    connect(friend, \.residences, to: [friendResidence], \.friend)

    let friendResidenceDuration: FriendResidenceDuration = .random
    friendResidenceDuration.friendResidenceId = friendResidence.id
    connect(friendResidence, \.durations, to: [friendResidenceDuration], \.residence)

    let friendQuote: FriendQuote = .random
    friendQuote.friendId = friend.id
    connect(friend, \.quotes, to: [friendQuote], \.friend)

    let document: Document = .random
    document.altLanguageId = nil
    document.friendId = friend.id
    connect(friend, \.documents, to: [document], \.friend)

    let documentTag: DocumentTag = .random
    documentTag.documentId = document.id
    connect(document, \.tags, to: [documentTag], \.document)

    let edition: Edition = .random
    edition.documentId = document.id
    connect(document, \.editions, to: [edition], \.document)

    let editionChapter: EditionChapter = .random
    editionChapter.editionId = edition.id
    connect(edition, \.chapters, to: [editionChapter], \.edition)

    let editionImpression: EditionImpression = .random
    editionImpression.editionId = edition.id
    connect(edition, \.impression, to: editionImpression, \.edition)

    let isbn: Isbn = .random
    isbn.editionId = edition.id
    connect(edition, \.isbn, to: isbn, \.edition)

    let audio: Audio = .random
    audio.editionId = edition.id
    connect(edition, \.audio, to: audio, \.edition)

    let audioPart: AudioPart = .random
    audioPart.audioId = audio.id
    connect(audio, \.parts, to: [audioPart], \.audio)

    var entities = Entities(
      friend: friend,
      friendResidence: friendResidence,
      friendResidenceDuration: friendResidenceDuration,
      friendQuote: friendQuote,
      document: document,
      documentTag: documentTag,
      edition: edition,
      editionChapter: editionChapter,
      editionImpression: editionImpression,
      isbn: isbn,
      audio: audio,
      audioPart: audioPart
    )

    beforePersist(&entities)

    _ = try! await Current.db.create(friend)
    _ = try! await Current.db.create(friendQuote)
    _ = try! await Current.db.create(friendResidence)
    _ = try! await Current.db.create(friendResidenceDuration)
    _ = try! await Current.db.create(document)
    _ = try! await Current.db.create(documentTag)
    _ = try! await Current.db.create(edition)
    _ = try! await Current.db.create(editionChapter)
    _ = try! await Current.db.create(editionImpression)
    _ = try! await Current.db.create(isbn)
    _ = try! await Current.db.create(audio)
    _ = try! await Current.db.create(audioPart)

    return entities
  }
}
