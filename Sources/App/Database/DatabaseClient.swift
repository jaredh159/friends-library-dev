import Fluent
import FluentSQL
import Tagged
import Vapor

struct DatabaseClient {
  // tokens
  var createToken: (Token) async throws -> Token
  var getToken: (Token.Id) async throws -> Token
  var getTokenByValue: (Token.Value) async throws -> Token
  var createTokenScope: (TokenScope) async throws -> TokenScope
  var getTokenScopes: (SQL.WhereConstraint?) async throws -> [TokenScope]

  // orders
  var getOrder: (Order.Id) async throws -> Order
  var getOrders: (SQL.WhereConstraint?) async throws -> [Order]
  var getOrdersByPrintJobStatus: (Order.PrintJobStatus) async throws -> [Order]
  var updateOrder: (Order) async throws -> Order
  var updateOrders: ([Order]) async throws -> [Order]
  var createOrder: (Order) async throws -> Order
  var createOrders: ([Order]) async throws -> [Order]
  var createOrderWithItems: (Order) async throws -> Order
  var deleteOrder: (Order.Id) async throws -> Order
  var deleteAllOrders: () async throws -> Void

  // order items
  var createOrderItem: (OrderItem) async throws -> OrderItem
  var createOrderItems: ([OrderItem]) async throws -> [OrderItem]
  var getOrderItem: (OrderItem.Id) async throws -> OrderItem
  var getOrderItems: (SQL.WhereConstraint?) async throws -> [OrderItem]
  var updateOrderItem: (OrderItem) async throws -> OrderItem
  var updateOrderItems: ([OrderItem]) async throws -> [OrderItem]
  var deleteOrderItem: (OrderItem.Id) async throws -> OrderItem

  // free order requests
  var createFreeOrderRequest: (FreeOrderRequest) async throws -> FreeOrderRequest
  var getFreeOrderRequest: (FreeOrderRequest.Id) async throws -> FreeOrderRequest

  // downloads
  var createDownload: (Download) async throws -> Download
  var createDownloads: ([Download]) async throws -> [Download]
  var getDownload: (Download.Id) async throws -> Download
  var getDownloads: (SQL.WhereConstraint?) async throws -> [Download]
  var updateDownload: (Download) async throws -> Download
  var updateDownloads: ([Download]) async throws -> [Download]
  var deleteDownload: (Download.Id) async throws -> Download
  var deleteAllDownloads: () async throws -> Void

  // friends
  var createFriend: (Friend) async throws -> Friend
  var createFriends: ([Friend]) async throws -> [Friend]
  var getFriend: (Friend.Id) async throws -> Friend
  var getFriends: (SQL.WhereConstraint?) async throws -> [Friend]
  var updateFriend: (Friend) async throws -> Friend
  var updateFriends: ([Friend]) async throws -> [Friend]
  var deleteFriend: (Friend.Id) async throws -> Friend
  var deleteAllFriends: () async throws -> Void

  // friend quotes
  var createFriendQuote: (FriendQuote) async throws -> FriendQuote
  var createFriendQuotes: ([FriendQuote]) async throws -> [FriendQuote]
  var getFriendQuote: (FriendQuote.Id) async throws -> FriendQuote
  var getFriendQuotes: (SQL.WhereConstraint?) async throws -> [FriendQuote]
  var updateFriendQuote: (FriendQuote) async throws -> FriendQuote
  var updateFriendQuotes: ([FriendQuote]) async throws -> [FriendQuote]
  var deleteFriendQuote: (FriendQuote.Id) async throws -> FriendQuote
  var deleteAllFriendQuotes: () async throws -> Void

  // friend residences
  var createFriendResidence: (FriendResidence) async throws -> FriendResidence
  var createFriendResidences: ([FriendResidence]) async throws -> [FriendResidence]
  var getFriendResidence: (FriendResidence.Id) async throws -> FriendResidence
  var getFriendResidences: (SQL.WhereConstraint?) async throws -> [FriendResidence]
  var updateFriendResidence: (FriendResidence) async throws -> FriendResidence
  var updateFriendResidences: ([FriendResidence]) async throws -> [FriendResidence]
  var deleteFriendResidence: (FriendResidence.Id) async throws -> FriendResidence
  var deleteAllFriendResidences: () async throws -> Void

  // friend residence durations
  var createFriendResidenceDuration:
    (FriendResidenceDuration) async throws -> FriendResidenceDuration
  var createFriendResidenceDurations:
    ([FriendResidenceDuration]) async throws -> [FriendResidenceDuration]
  var getFriendResidenceDuration:
    (FriendResidenceDuration.Id) async throws -> FriendResidenceDuration
  var getFriendResidenceDurations: (SQL.WhereConstraint?) async throws -> [FriendResidenceDuration]
  var updateFriendResidenceDuration:
    (FriendResidenceDuration) async throws -> FriendResidenceDuration
  var updateFriendResidenceDurations:
    ([FriendResidenceDuration]) async throws -> [FriendResidenceDuration]
  var deleteFriendResidenceDuration:
    (FriendResidenceDuration.Id) async throws -> FriendResidenceDuration
  var deleteAllFriendResidenceDurations: () async throws -> Void

  // documents
  var createDocument: (Document) async throws -> Document
  var createDocuments: ([Document]) async throws -> [Document]
  var getDocument: (Document.Id) async throws -> Document
  var getDocuments: (SQL.WhereConstraint?) async throws -> [Document]
  var updateDocument: (Document) async throws -> Document
  var updateDocuments: ([Document]) async throws -> [Document]
  var deleteDocument: (Document.Id) async throws -> Document
  var deleteAllDocuments: () async throws -> Void

  // related documents
  var createRelatedDocument: (RelatedDocument) async throws -> RelatedDocument
  var createRelatedDocuments: ([RelatedDocument]) async throws -> [RelatedDocument]
  var getRelatedDocument: (RelatedDocument.Id) async throws -> RelatedDocument
  var getRelatedDocuments: (SQL.WhereConstraint?) async throws -> [RelatedDocument]
  var updateRelatedDocument: (RelatedDocument) async throws -> RelatedDocument
  var updateRelatedDocuments: ([RelatedDocument]) async throws -> [RelatedDocument]
  var deleteRelatedDocument: (RelatedDocument.Id) async throws -> RelatedDocument
  var deleteAllRelatedDocuments: () async throws -> Void

  // editions
  var createEdition: (Edition) async throws -> Edition
  var createEditions: ([Edition]) async throws -> [Edition]
  var getEdition: (Edition.Id) async throws -> Edition
  // TODO
  var getEditionIsbn: (Edition.Id) async throws -> Isbn?
  // TODO
  var getEditionAudio: (Edition.Id) async throws -> Audio?
  // TODO
  var getEditionEditionImpression: (Edition.Id) async throws -> EditionImpression?
  var getEditions: (SQL.WhereConstraint?) async throws -> [Edition]
  var updateEdition: (Edition) async throws -> Edition
  var updateEditions: ([Edition]) async throws -> [Edition]
  var deleteEdition: (Edition.Id) async throws -> Edition
  var deleteAllEditions: () async throws -> Void

  // editions impressions
  var createEditionImpression: (EditionImpression) async throws -> EditionImpression
  var createEditionImpressions: ([EditionImpression]) async throws -> [EditionImpression]
  var getEditionImpression: (EditionImpression.Id) async throws -> EditionImpression
  var getEditionImpressions: (SQL.WhereConstraint?) async throws -> [EditionImpression]
  var updateEditionImpression: (EditionImpression) async throws -> EditionImpression
  var updateEditionImpressions: ([EditionImpression]) async throws -> [EditionImpression]
  var deleteEditionImpression: (EditionImpression.Id) async throws -> EditionImpression
  var deleteAllEditionImpressions: () async throws -> Void

  // edition chapters
  var createEditionChapter: (EditionChapter) async throws -> EditionChapter
  var createEditionChapters: ([EditionChapter]) async throws -> [EditionChapter]
  var getEditionChapter: (EditionChapter.Id) async throws -> EditionChapter
  var getEditionChapters: (SQL.WhereConstraint?) async throws -> [EditionChapter]
  var updateEditionChapter: (EditionChapter) async throws -> EditionChapter
  var updateEditionChapters: ([EditionChapter]) async throws -> [EditionChapter]
  var deleteEditionChapter: (EditionChapter.Id) async throws -> EditionChapter
  var deleteAllEditionChapters: () async throws -> Void

  // audios
  var createAudio: (Audio) async throws -> Audio
  var createAudios: ([Audio]) async throws -> [Audio]
  var getAudio: (Audio.Id) async throws -> Audio
  var getAudios: (SQL.WhereConstraint?) async throws -> [Audio]
  var updateAudio: (Audio) async throws -> Audio
  var updateAudios: ([Audio]) async throws -> [Audio]
  var deleteAudio: (Audio.Id) async throws -> Audio
  var deleteAllAudios: () async throws -> Void

  // audio parts
  var createAudioPart: (AudioPart) async throws -> AudioPart
  var createAudioParts: ([AudioPart]) async throws -> [AudioPart]
  var getAudioPart: (AudioPart.Id) async throws -> AudioPart
  var getAudioParts: (SQL.WhereConstraint?) async throws -> [AudioPart]
  var updateAudioPart: (AudioPart) async throws -> AudioPart
  var updateAudioParts: ([AudioPart]) async throws -> [AudioPart]
  var deleteAudioPart: (AudioPart.Id) async throws -> AudioPart
  var deleteAllAudioParts: () async throws -> Void

  // isbns
  var createIsbn: (Isbn) async throws -> Isbn
  var createIsbns: ([Isbn]) async throws -> [Isbn]
  var getIsbn: (Isbn.Id) async throws -> Isbn
  var getIsbns: (SQL.WhereConstraint?) async throws -> [Isbn]
  var updateIsbn: (Isbn) async throws -> Isbn
  var updateIsbns: ([Isbn]) async throws -> [Isbn]
  var deleteIsbn: (Isbn.Id) async throws -> Isbn
  var deleteAllIsbns: () async throws -> Void

  // document tags
  var createDocumentTagModels: ([DocumentTagModel]) async throws -> [DocumentTagModel]

  // artifact production versions
  var createArtifactProductionVersion:
    (ArtifactProductionVersion) async throws -> ArtifactProductionVersion
  var getLatestArtifactProductionVersion: () async throws -> ArtifactProductionVersion
}
