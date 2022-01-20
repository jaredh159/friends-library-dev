import Fluent
import Vapor

struct AddShippingLevelGroundBus: AsyncMigration {

  func prepare(on database: Database) async throws {
    _ = try await database.enum(Order.M2.ShippingLevelEnum.name)
      .case(M16.ShippingLevelEnum.caseGroundBus)
      .update()
  }

  func revert(on database: Database) async throws {
    // I don't think postgres supports deleting enum cases... ¯\_(ツ)_/¯
  }
}

extension AddShippingLevelGroundBus {
  enum M16 {
    enum ShippingLevelEnum {
      static let caseGroundBus = "groundBus"
    }
  }
}
