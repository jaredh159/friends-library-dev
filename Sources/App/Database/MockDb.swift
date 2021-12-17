final class MockDb {
  var tokens: [Token.Id: Token] = [:]
  var tokenScopes: [TokenScope.Id: TokenScope] = [:]
  var orders: [Order.Id: Order] = [:]
  var freeOrderRequests: [FreeOrderRequest.Id: FreeOrderRequest] = [:]
  var downloads: [Download.Id: Download] = [:]
  var orderItems: [OrderItem.Id: OrderItem] = [:]
  var artifactProductionVersions: [ArtifactProductionVersion.Id: ArtifactProductionVersion] = [:]

  func find<M: DuetModel>(
    _ id: M.IdValue,
    in keyPath: ReferenceWritableKeyPath<MockDb, [M.IdValue: M]>
  ) throws -> M {
    guard let model = self[keyPath: keyPath][id] else {
      throw DbError.notFound
    }
    return model
  }

  func all<M: DuetModel>(_ keyPath: KeyPath<MockDb, [M.IdValue: M]>) -> [M] {
    Array(self[keyPath: keyPath].values)
  }

  func find<M: DuetModel>(
    where predicate: (M) -> Bool,
    in keyPath: ReferenceWritableKeyPath<MockDb, [M.IdValue: M]>
  ) -> [M] {
    self[keyPath: keyPath].values.filter(predicate)
  }

  func first<M: DuetModel>(
    where predicate: (M) -> Bool,
    in keyPath: ReferenceWritableKeyPath<MockDb, [M.IdValue: M]>
  ) throws -> M {
    guard let model = self[keyPath: keyPath].values.first(where: predicate) else {
      throw DbError.notFound
    }
    return model
  }

  func add<M: DuetModel>(_ model: M, to keyPath: ReferenceWritableKeyPath<MockDb, [M.IdValue: M]>) {
    self[keyPath: keyPath][model.id] = model
  }
}
