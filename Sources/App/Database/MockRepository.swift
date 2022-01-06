struct MockRepository<Model: DuetModel> {
  let db: MockDb
  let models: ReferenceWritableKeyPath<MockDb, [Model.IdValue: Model]>

  // CREATE

  @discardableResult
  func create(_ model: Model) async throws -> Model {
    db.add(model, to: models)
  }

  @discardableResult
  func create(_ models: [Model]) async throws -> [Model] {
    models.forEach { db.add($0, to: self.models) }
    return models
  }

  // READ

  @discardableResult
  func find(_ id: Model.IdValue) async throws -> Model {
    try db.find(id, in: models)
  }

  func find(where constraint: SQL.WhereConstraint) async throws -> Model {
    try await findAll(where: constraint).firstOrThrowNotFound()
  }

  func findAll(where constraint: SQL.WhereConstraint? = nil) async throws -> [Model] {
    guard let constraint = constraint else { return db.all(models) }
    return db.find(where: { $0.satisfies(constraint: constraint) }, in: models)
  }

  // UPDATE

  func update(_ model: Model) async throws -> Model {
    try await find(model.id)
    return try await create(model)
  }

  func update(_ models: [Model]) async throws -> [Model] {
    for model in models {
      _ = try await update(model)
    }
    return models
  }

  // DELETE

  func delete(_ id: Model.IdValue) async throws -> Model {
    let model = try await find(id)
    let without = db[keyPath: models].drop { key, _ in key == id }
    db[keyPath: models] = [:]
    for (key, value) in without {
      db[keyPath: models][key] = value
    }
    return model
  }

  func deleteAll() async throws {
    db[keyPath: models] = [:]
  }

  func assign(client: inout DatabaseClient) {
    // no-op customization point
  }
}
