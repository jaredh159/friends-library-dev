import Fluent
import Foundation
import Graphiti
import Vapor

final class Resolver {
  struct IdentifyEntityArgs: Codable {
    let id: UUID
  }

  func getLol(request: Request, argument: NoArguments) -> [String] {
    return ["lol"]
  }
}
