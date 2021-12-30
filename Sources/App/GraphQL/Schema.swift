import Fluent
import Foundation
import Graphiti
import Vapor

let AppSchema = try! Graphiti.Schema<Resolver, Request> {
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

  ArtifactProductionVersion.GraphQL.Schema.type
  ArtifactProductionVersion.GraphQL.Schema.Inputs.create

  Download.GraphQL.Schema.type
  Download.GraphQL.Schema.Inputs.create

  Query {
    ArtifactProductionVersion.GraphQL.Schema.Queries.get
  }

  Mutation {
    Download.GraphQL.Schema.Mutations.create
  }

  // Types(OrderItem.self, TokenScope.self)
}
