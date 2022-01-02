import Fluent
import Foundation
import Graphiti
import Vapor

let appSchema = try! Graphiti.Schema<Resolver, Request> {
  Scalar(UUID.self)
  DateScalar(formatter: ISO8601DateFormatter())

  Enum(EditionType.self)
  Enum(Lang.self)

  Enum(Download.Format.self)
  Enum(Download.AudioQuality.self)
  Enum(Download.DownloadSource.self)
  Enum(Order.PrintJobStatus.self)
  Enum(Order.ShippingLevel.self)
  Enum(Order.OrderSource.self)
  Enum(Scope.self)
  Enum(Friend.Gender.self)
  Enum(PrintSizeVariant.self)

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

  // isbn types
  AppSchema.IsbnType
  AppSchema.CreateIsbnInputType
  AppSchema.UpdateIsbnInputType

  // friend types
  AppSchema.FriendType
  AppSchema.CreateFriendInputType
  AppSchema.UpdateFriendInputType

  // document types
  AppSchema.DocumentType
  AppSchema.CreateDocumentInputType
  AppSchema.UpdateDocumentInputType

  // edition types
  AppSchema.EditionType
  AppSchema.CreateEditionInputType
  AppSchema.UpdateEditionInputType

  Query {
    AppSchema.getFriend
    AppSchema.getDocument
    AppSchema.getEdition
    AppSchema.getIsbn

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
    AppSchema.createDownload
    AppSchema.createArtifactProductionVersion

    // isbn mutations
    AppSchema.createIsbn
    AppSchema.updateIsbn
    AppSchema.deleteIsbn

    // friend mutations
    AppSchema.createFriend
    AppSchema.updateFriend
    AppSchema.deleteFriend

    // document mutations
    AppSchema.createDocument
    AppSchema.updateDocument
    AppSchema.deleteDocument

    // edition mutations
    AppSchema.createEdition
    AppSchema.updateEdition
    AppSchema.deleteEdition

    // order mutations
    AppSchema.updateOrder
    AppSchema.updateOrders
    AppSchema.createFreeOrderRequest
    Field("createOrderWithItems", at: Resolver.createOrderWithItems) {
      Argument("order", at: \.order)
      Argument("items", at: \.items)
    }
  }

  Types(OrderItem.self, TokenScope.self)
}
