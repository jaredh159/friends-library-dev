extension MockRepository {

  // CREATE

  func create(_ model: Model) async throws {
    db.add(model, to: models)
  }

  func create(_ models: [Model]) async throws {
    models.forEach { db.add($0, to: self.models) }
  }

  // READ

  func find(_ id: Model.IdValue) async throws -> Model {
    try db.find(id, in: models)
  }

  func select(where predicate: ((Model) -> Bool)? = nil) async throws -> [Model] {
    guard let predicate = predicate else { return db.all(models) }
    return db.find(where: predicate, in: models)
  }

  // UPDATE

  // DELETE

  func delete(_ id: Model.IdValue) async throws {
    let without = db[keyPath: models].drop { key, _ in key == id }
    db[keyPath: models] = [:]
    for (key, value) in without {
      db[keyPath: models][key] = value
    }
  }

  func deleteAll() async throws {
    db[keyPath: models] = [:]
  }
}
