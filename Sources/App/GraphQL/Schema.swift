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

  AppSchema.ArtifactProductionVersionType
  AppSchema.CreateArtifactProductionVersionInputType

  AppSchema.DownloadType
  AppSchema.CreateDownloadInputType

  AppSchema.TokenType
  AppSchema.TokenScopeType

  Query {
    Field("getLatestArtifactProductionVersion", at: Resolver.getArtifactProductionVersion)

    Field("getTokenByValue", at: Resolver.getTokenByValue) {
      Argument("value", at: \.value)
    }
  }

  Mutation {
    AppSchema.createDownload
    AppSchema.createArtifactProductionVersion
  }

  Types(TokenScope.self)
  // Types(OrderItem.self, TokenScope.self)
}
