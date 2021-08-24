import Fluent
import Foundation
import Graphiti
import Vapor

let AppSchema = try! Graphiti.Schema<Resolver, Request> {
  Scalar(UUID.self)
  DateScalar(formatter: ISO8601DateFormatter())

  Query {
    Field("getLol", at: Resolver.getLol)
  }
}
