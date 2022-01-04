extension LiveRepository {

  // CREATE

  @discardableResult
  func create(_ model: Model) async throws -> Model {
    try await create([model])
    return model
  }

  @discardableResult
  func create(_ models: [Model]) async throws -> [Model] {
    let prepared = try SQL.insert(into: Model.tableName, values: models.map(\.insertValues))
    _ = try await SQL.execute(prepared, on: db).all()
    return models
  }

  @discardableResult
  func createRelation<Relation: DuetModel>(_ relation: Relation) async throws -> Relation {
    try await createRelations([relation])
    return relation
  }

  @discardableResult
  func createRelations<Relation: DuetModel>(_ relations: [Relation]) async throws -> [Relation] {
    let prepared = try SQL.insert(
      into: Relation.tableName,
      values: relations.map(\.insertValues)
    )
    _ = try await SQL.execute(prepared, on: db).all()
    return relations
  }

  // READ

  func find(_ id: Model.IdValue) async throws -> Model {
    let prepared = SQL.select(.all, from: Model.tableName, where: ("id", .equals, .uuid(id)))
    let rows = try await SQL.execute(prepared, on: db).all()
    return try rows.compactMap { try $0.decode(Model.self) }.firstOrThrowNotFound()
  }

  func select(
    _ columns: Postgres.Columns = .all,
    where: SQL.WhereConstraint? = nil
  ) async throws -> [Model] {
    let prepared = SQL.select(columns, from: Model.tableName, where: `where`)
    let rows = try await SQL.execute(prepared, on: db).all()
    return try rows.compactMap { try $0.decode(Model.self) }
  }

  func selectRelation<Relation: DuetModel>(
    _ columns: Postgres.Columns = .all,
    from model: Relation.Type,
    where: SQL.WhereConstraint? = nil
  ) async throws -> [Relation] {
    let prepared = SQL.select(columns, from: model.tableName, where: `where`)
    let rows = try await SQL.execute(prepared, on: db).all()
    return try rows.compactMap { try $0.decode(model) }
  }

  // UPDATE

  func update(_ model: Model) async throws -> Model {
    let prepared = SQL.update(
      Model.tableName,
      set: model.updateValues,
      where: ("id", .equals, .id(model)),
      returning: .all
    )
    return try await SQL.execute(prepared, on: db).all()
      .compactMap { try $0.decode(Model.self) }
      .firstOrThrowNotFound()
  }

  func update(_ models: [Model]) async throws -> [Model] {
    try await withThrowingTaskGroup(of: Model.self) { group in
      for model in models {
        group.addTask { try await update(model) }
      }
      var updated: [Model] = []
      for try await updatedModel in group {
        updated.append(updatedModel)
      }
      return updated
    }
  }

  // DELETE

  @discardableResult
  func delete(_ id: Model.IdValue) async throws -> Model {
    // let model = try await find(id)
    fatalError("LiveRepository+CRUD.delete() not implemented")
  }

  func deleteAll() async throws {
    _ = try await db.raw("DELETE FROM \(table: Model.self)").all().get()
  }
}
