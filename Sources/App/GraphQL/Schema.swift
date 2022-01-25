import Fluent
import Foundation
import Graphiti
import Vapor

let appSchema = try! Graphiti.Schema<Resolver, Request> {
  Scalar(UUID.self)
  Scalar(Int64.self)
  DateScalar(formatter: ISO8601DateFormatter())

  Enum(EditionType.self)
  Enum(Lang.self)
  Enum(Download.Format.self)
  Enum(Download.AudioQuality.self)
  Enum(Download.DownloadSource.self)
  Enum(Order.PrintJobStatus.self)
  Enum(Order.ShippingLevel.self)
  Enum(Order.OrderSource.self)
  Enum(DocumentTag.TagType.self)
  Enum(Scope.self)
  Enum(Friend.Gender.self)
  Enum(PrintSizeVariant.self)
  Enum(AppSchema.SubmitContactFormInput.Subject.self)

  AppSchema.GenericResponseType
  AppSchema.ShippingAddressType
  AppSchema.SubmitContactFormInputType
  AppSchema.LogJsErrorDataInputType

  // isbn types
  AppSchema.IsbnType
  AppSchema.CreateIsbnInputType
  AppSchema.UpdateIsbnInputType

  AppSchema.ArtifactProductionVersionType
  AppSchema.CreateArtifactProductionVersionInputType

  AppSchema.DownloadType
  AppSchema.CreateDownloadInputType

  AppSchema.TokenType
  AppSchema.TokenScopeType

  // order types
  AppSchema.OrderType
  AppSchema.OrderItemType
  AppSchema.CreateOrderInputType
  AppSchema.CreateOrderItemInputType
  AppSchema.UpdateOrderInputType
  AppSchema.FreeOrderRequestType
  AppSchema.CreateFreeOrderRequestInputType
  AppSchema.OrderInitializationType
  AppSchema.CreateOrderInitializationInputType
  AppSchema.BrickOrderInputType

  // friend types
  AppSchema.FriendType
  AppSchema.CreateFriendInputType
  AppSchema.UpdateFriendInputType
  AppSchema.FriendQuoteType
  AppSchema.CreateFriendQuoteInputType
  AppSchema.UpdateFriendQuoteInputType
  AppSchema.FriendResidenceType
  AppSchema.CreateFriendResidenceInputType
  AppSchema.UpdateFriendResidenceInputType
  AppSchema.FriendResidenceDurationType
  AppSchema.CreateFriendResidenceDurationInputType
  AppSchema.UpdateFriendResidenceDurationInputType

  // document types
  AppSchema.DocumentType
  AppSchema.CreateDocumentInputType
  AppSchema.UpdateDocumentInputType
  AppSchema.DocumentTagType
  AppSchema.RelatedDocumentType

  // edition types
  AppSchema.EditionImageType
  AppSchema.EditionSquareImagesType
  AppSchema.EditionThreeDImagesType
  AppSchema.EditionImagesType
  AppSchema.EditionType
  AppSchema.CreateEditionInputType
  AppSchema.UpdateEditionInputType

  // edition impression types
  AppSchema.EditionImpressionFileType
  AppSchema.EditionImpressionFilesType
  AppSchema.EditionImpressionType
  AppSchema.CreateEditionImpressionInputType
  AppSchema.UpdateEditionImpressionInputType

  // edition chapter types
  AppSchema.EditionChapterType
  AppSchema.CreateEditionChapterInputType
  AppSchema.UpdateEditionChapterInputType

  // audio types
  AppSchema.AudioType
  AppSchema.CreateAudioInputType
  AppSchema.UpdateAudioInputType
  AppSchema.AudioPartType
  AppSchema.CreateAudioPartInputType
  AppSchema.UpdateAudioPartInputType

  Query {
    AppSchema.getFriend
    AppSchema.getFriendQuote
    AppSchema.getFriendResidence
    AppSchema.getFriendResidenceDuration
    AppSchema.getDocument
    AppSchema.getDocumentTag
    AppSchema.getEdition
    AppSchema.getEditionImpression
    AppSchema.getIsbn
    AppSchema.getEditionChapter
    AppSchema.getAudio
    AppSchema.getAudioPart

    Field("getLatestArtifactProductionVersion", at: Resolver.getLatestArtifactProductionVersion)

    Field("getTokenByValue", at: Resolver.getTokenByValue) {
      Argument("value", at: \.value)
    }

    // order queries
    AppSchema.getOrder
    AppSchema.getFreeOrderRequest
    Field("getOrdersByPrintJobStatus", at: Resolver.getOrdersByPrintJobStatus) {
      Argument("printJobStatus", at: \.printJobStatus)
    }
  }

  Mutation {
    AppSchema.submitContactForm
    AppSchema.createDownload
    AppSchema.createArtifactProductionVersion
    AppSchema.logJsError

    // isbn mutations
    AppSchema.createIsbn
    AppSchema.updateIsbn
    AppSchema.deleteIsbn

    // friend mutations
    AppSchema.createFriend
    AppSchema.updateFriend
    AppSchema.deleteFriend
    AppSchema.createFriendQuote
    AppSchema.updateFriendQuote
    AppSchema.deleteFriendQuote
    AppSchema.createFriendResidence
    AppSchema.updateFriendResidence
    AppSchema.deleteFriendResidence
    AppSchema.createFriendResidenceDuration
    AppSchema.updateFriendResidenceDuration
    AppSchema.deleteFriendResidenceDuration

    // document mutations
    AppSchema.createDocument
    AppSchema.updateDocument
    AppSchema.deleteDocument

    // edition mutations
    AppSchema.createEdition
    AppSchema.updateEdition
    AppSchema.deleteEdition

    // edition impression mutations
    AppSchema.createEditionImpression
    AppSchema.updateEditionImpression
    AppSchema.deleteEditionImpression

    // edition chapter mutations
    AppSchema.createEditionChapter
    AppSchema.updateEditionChapter
    AppSchema.deleteEditionChapter

    // audio mutations
    AppSchema.createAudio
    AppSchema.updateAudio
    AppSchema.deleteAudio
    AppSchema.createAudioPart
    AppSchema.updateAudioPart
    AppSchema.deleteAudioPart

    // order mutations
    AppSchema.updateOrder
    AppSchema.updateOrders
    AppSchema.createFreeOrderRequest
    AppSchema.createOrderInitialization
    AppSchema.brickOrder
    Field("createOrderWithItems", at: Resolver.createOrderWithItems) {
      Argument("order", at: \.order)
      Argument("items", at: \.items)
    }
  }

  Types(OrderItem.self, TokenScope.self, RelatedDocument.self)
}
