import FluentSQL

protocol SQLQuerying {
  func select<M: DuetModel>(_ Model: M.Type, where: [SQL.WhereConstraint]) async throws -> [M]
}

protocol SQLMutating {
  @discardableResult
  func create<M: DuetModel>(_ models: [M]) async throws -> [M]

  @discardableResult
  func update<M: DuetModel>(_ model: M) async throws -> M

  @discardableResult
  func forceDelete<M: DuetModel>(_ Model: M.Type, where: SQL.WhereConstraint?) async throws -> [M]
}

extension SQLMutating {
  @discardableResult
  func create<M: DuetModel>(_ model: M) async throws -> M {
    let models = try await create([model])
    return models.first ?? model
  }

  @discardableResult
  func delete<M: DuetModel>(
    _ Model: M.Type,
    where constraint: SQL.WhereConstraint? = nil
  ) async throws -> [M] {
    try await forceDelete(Model, where: constraint)
  }

  @discardableResult
  func delete<M: DuetModel>(_ Model: M.Type, byId id: M.IdValue) async throws -> M {
    try await forceDelete(Model, where: "id" == .uuid(id)).firstOrThrowNotFound()
  }

  @discardableResult
  func delete<M: DuetModel>(_ model: M) async throws -> M {
    try await forceDelete(M.self, where: "id" == .id(model)).firstOrThrowNotFound()
  }

  @discardableResult
  func update<M: DuetModel>(_ models: [M]) async throws -> [M] {
    try await withThrowingTaskGroup(of: M.self) { group in
      for model in models {
        group.addTask { try await update(model) }
      }
      var updated: [M] = []
      for try await updatedModel in group {
        updated.append(updatedModel)
      }
      return updated
    }
  }
}

extension SQLMutating {
  @discardableResult
  func delete<M: SoftDeletable>(_ Model: M.Type, byId id: M.IdValue) async throws -> M {
    fatalError("\(type(of: Self.self)) does not implement soft deletes!")
  }

  @discardableResult
  func delete<M: SoftDeletable>(
    _ Model: M.Type,
    where constraint: SQL.WhereConstraint? = nil
  ) async throws -> [M] {
    fatalError("\(type(of: Self.self)) does not implement soft deletes!")
  }

  @discardableResult
  func delete<M: SoftDeletable>(_ model: M) async throws -> M {
    fatalError("\(type(of: Self.self)) does not implement soft deletes!")
  }
}

extension SQLMutating where Self: SQLQuerying {
  @discardableResult
  func delete<M: SoftDeletable>(_ Model: M.Type, byId id: M.IdValue) async throws -> M {
    var model = try await find(Model.self, byId: id)
    model.deletedAt = Current.date()
    return try await update(model)
  }

  @discardableResult
  func delete<M: SoftDeletable>(
    _ Model: M.Type,
    where constraint: SQL.WhereConstraint? = nil
  ) async throws -> [M] {
    let models = try await select(Model.self, where: [constraint].compactMap { $0 })
    for var model in models {
      model.deletedAt = Current.date()
    }
    return try await update(models)
  }

  @discardableResult
  func delete<M: SoftDeletable>(_ model: M) async throws -> M {
    var model = try await find(M.self, byId: model.id)
    model.deletedAt = Current.date()
    return try await update(model)
  }
}

extension SQLQuerying {

  func find<M: DuetModel>(_ Model: M.Type, byId id: M.IdValue) async throws -> M {
    fatalError()
    // try await select(M.self, where: ["id" == .uuid(id)]).firstOrThrowNotFound()
  }

  func find<M: DuetModel>(
    _ Model: M.Type,
    where constraint: SQL.WhereConstraint
  ) async throws -> M {
    fatalError()
    // try await select(M.self, where: constraint).firstOrThrowNotFound()
  }

  func findOptional<M: DuetModel>(
    _ Model: M.Type,
    where constraint: SQL.WhereConstraint
  ) async throws -> M? {
    fatalError()
    // try await select(M.self, where: constraint).first ?? nil
  }

  func findAll<M: DuetModel>(
    _ Model: M.Type,
    where constraint: SQL.WhereConstraint? = nil
  ) async throws -> [M] {
    fatalError()
    // try await select(Model, where: constraint)
  }

  func findAll<M: SoftDeletable>(
    _ Model: M.Type,
    where constraint: SQL.WhereConstraint? = nil,
    withDeleted: Bool = false
  ) async throws -> [M] {
    fatalError()
    // try await select(Model, where: constraint).filter { withDeleted || $0.deletedAt == nil }
  }
}

struct GenericRepository: SQLQuerying, SQLMutating {
  let db: SQLDatabase

  func query<M: DuetModel>(_ Model: M.Type) -> DuetQuery<M> {
    DuetQuery<M>(db: self, constraints: [], limit: nil, order: nil)
  }

  @discardableResult
  func create<M: DuetModel>(_ models: [M]) async throws -> [M] {
    guard !models.isEmpty else { return models }
    let prepared = try SQL.insert(into: M.tableName, values: models.map(\.insertValues))
    _ = try await SQL.execute(prepared, on: db).all()
    return models
  }

  @discardableResult
  func update<M: DuetModel>(_ model: M) async throws -> M {
    let prepared = SQL.update(
      M.tableName,
      set: model.updateValues,
      where: [("id", .equals, .id(model))],
      returning: .all
    )
    return try await SQL.execute(prepared, on: db).all()
      .compactMap { try $0.decode(M.self) }
      .firstOrThrowNotFound()
  }

  @discardableResult
  func forceDelete<M: DuetModel>(
    _ Model: M.Type,
    where constraint: SQL.WhereConstraint?
  ) async throws -> [M] {
    let models = try await findAll(M.self, where: constraint)
    guard !models.isEmpty else { return models }
    let prepared = SQL.delete(from: M.tableName, where: [constraint].compactMap { $0 })
    _ = try await SQL.execute(prepared, on: db).all()
    return models
  }

  @discardableResult
  func delete<M: SoftDeletable>(
    _ Model: M.Type,
    where constraint: SQL.WhereConstraint? = nil
  ) async throws -> [M] {
    let models = try await select(Model.self, where: [constraint].compactMap { $0 })
    let prepared = SQL.update(
      M.tableName,
      set: ["deleted_at": .currentTimestamp],
      where: [constraint].compactMap { $0 }
    )
    _ = try await SQL.execute(prepared, on: db).all()
    return models
  }

  func select<M: DuetModel>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint] = []
  ) async throws -> [M] {
    let prepared = SQL.select(.all, from: M.tableName, where: constraints)
    let rows = try await SQL.execute(prepared, on: db).all()
    return try rows.compactMap { try $0.decode(Model.self) }
  }
}

struct MockGenericRepository: SQLQuerying, SQLMutating {
  let db: MockDb

  @discardableResult
  func create<M: DuetModel>(_ models: [M]) async throws -> [M] {
    let keyPath = db.models(of: M.self)
    for model in models {
      db[keyPath: keyPath][model.id] = model
    }
    return models
  }

  @discardableResult
  func forceDelete<M: DuetModel>(
    _ Model: M.Type,
    where constraint: SQL.WhereConstraint?
  ) async throws -> [M] {
    let keyPath = db.models(of: Model)
    let models = db.find(where: { $0.satisfies(constraint: constraint) }, in: keyPath)
    for model in models {
      if model.satisfies(constraint: constraint) {
        db[keyPath: keyPath][model.id] = nil
      }
    }
    return models
  }

  @discardableResult
  func update<M: DuetModel>(_ model: M) async throws -> M {
    let model = try await find(M.self, byId: model.id)
    db[keyPath: db.models(of: M.self)][model.id] = model
    return model
  }

  func select<M: DuetModel>(
    _ Model: M.Type,
    where constraint: [SQL.WhereConstraint] = []
  ) async throws -> [M] {
    fatalError()
    // db.find(where: { $0.satisfies(constraint: constraint) }, in: db.models(of: Model.self))
  }
}
