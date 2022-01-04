import Fluent
import FluentSQL
import Tagged
import Vapor

struct DatabaseClient {
  // tokens
  var createToken: (Token) async throws -> Token
  var getTokenByValue: (Token.Value) async throws -> Token
  var createTokenScope: (TokenScope) async throws -> TokenScope
  var getTokenScopes: (Token.Id) async throws -> [TokenScope]

  // orders
  var deleteAllOrders: () async throws -> Void
  var createOrderWithItems: (Order) async throws -> Order
  var getOrder: (Order.Id) async throws -> Order
  var getOrdersByPrintJobStatus: (Order.PrintJobStatus) async throws -> [Order]
  var updateOrder: (Order) async throws -> Order
  var updateOrders: ([Order]) async throws -> [Order]

  // free order requests
  var createFreeOrderRequest: (FreeOrderRequest) async throws -> FreeOrderRequest
  var getFreeOrderRequest: (FreeOrderRequest.Id) async throws -> FreeOrderRequest

  // downloads
  var createDownload: (Download) async throws -> Download
  var getDownload: (Download.Id) async throws -> Download

  // friends
  var createFriend: (Friend) async throws -> Friend
  var createFriends: ([Friend]) async throws -> [Friend]
  var getFriend: (Friend.Id) async throws -> Friend
  var getFriends: () async throws -> [Friend]
  var updateFriend: (Friend) async throws -> Friend
  var updateFriends: ([Friend]) async throws -> [Friend]
  var deleteFriend: (Friend.Id) async throws -> Friend
  var deleteAllFriends: () async throws -> Void

  // documents
  var createDocument: (Document) async throws -> Document
  var createDocuments: ([Document]) async throws -> [Document]
  var getDocument: (Document.Id) async throws -> Document
  var getDocuments: () async throws -> [Document]
  var updateDocument: (Document) async throws -> Document
  var updateDocuments: ([Document]) async throws -> [Document]
  var deleteDocument: (Document.Id) async throws -> Document
  var deleteAllDocuments: () async throws -> Void

  // editions
  var createEdition: (Edition) async throws -> Edition
  var createEditions: ([Edition]) async throws -> [Edition]
  var getEdition: (Edition.Id) async throws -> Edition
  var getEditions: () async throws -> [Edition]
  var updateEdition: (Edition) async throws -> Edition
  var updateEditions: ([Edition]) async throws -> [Edition]
  var deleteEdition: (Edition.Id) async throws -> Edition
  var deleteAllEditions: () async throws -> Void

  // editions impressions
  var createEditionImpression: (EditionImpression) async throws -> EditionImpression
  var createEditionImpressions: ([EditionImpression]) async throws -> [EditionImpression]
  var getEditionImpression: (EditionImpression.Id) async throws -> EditionImpression
  var getEditionImpressions: () async throws -> [EditionImpression]
  var updateEditionImpression: (EditionImpression) async throws -> EditionImpression
  var updateEditionImpressions: ([EditionImpression]) async throws -> [EditionImpression]
  var deleteEditionImpression: (EditionImpression.Id) async throws -> EditionImpression
  var deleteAllEditionImpressions: () async throws -> Void

  // edition chapters
  var createEditionChapter: (EditionChapter) async throws -> EditionChapter
  var createEditionChapters: ([EditionChapter]) async throws -> [EditionChapter]
  var getEditionChapter: (EditionChapter.Id) async throws -> EditionChapter
  var getEditionChapters: () async throws -> [EditionChapter]
  var updateEditionChapter: (EditionChapter) async throws -> EditionChapter
  var updateEditionChapters: ([EditionChapter]) async throws -> [EditionChapter]
  var deleteEditionChapter: (EditionChapter.Id) async throws -> EditionChapter
  var deleteAllEditionChapters: () async throws -> Void

  // audios
  var createAudio: (Audio) async throws -> Audio
  var createAudios: ([Audio]) async throws -> [Audio]
  var getAudio: (Audio.Id) async throws -> Audio
  var getAudios: () async throws -> [Audio]
  var updateAudio: (Audio) async throws -> Audio
  var updateAudios: ([Audio]) async throws -> [Audio]
  var deleteAudio: (Audio.Id) async throws -> Audio
  var deleteAllAudios: () async throws -> Void

  // isbns
  var createIsbn: (Isbn) async throws -> Isbn
  var createIsbns: ([Isbn]) async throws -> [Isbn]
  var getIsbn: (Isbn.Id) async throws -> Isbn
  var getIsbns: () async throws -> [Isbn]
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
