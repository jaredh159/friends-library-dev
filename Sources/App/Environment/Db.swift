import Fluent
import FluentSQL
import Tagged
import Vapor

struct Db {
  var createToken: (Alt.Token) -> Future<Void>
  var getTokenByValue: (Alt.Token.Value) throws -> Future<Alt.Token>
  var createTokenScope: (Alt.TokenScope) -> Future<Void>
  var getTokenScopes: (Alt.Token.Id) throws -> Future<[Alt.TokenScope]>
}

extension String {
  var snakeCased: String {
    let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
    let normalPattern = "([a-z0-9])([A-Z])"
    return self.processCamalCaseRegex(pattern: acronymPattern)?
      .processCamalCaseRegex(pattern: normalPattern)?.lowercased() ?? self.lowercased()
  }

  fileprivate func processCamalCaseRegex(pattern: String) -> String? {
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(location: 0, length: count)
    return regex?.stringByReplacingMatches(
      in: self, options: [], range: range, withTemplate: "$1_$2")
  }
}

extension SQLRow {
  func decode<M: AltModel>(_ type: M.Type) throws -> M {
    try decode(model: M.self, prefix: nil, keyDecodingStrategy: .convertFromSnakeCase)
  }
}

extension SQLQueryString {
  mutating func appendInterpolation<T: RawRepresentable>(id: T) where T.RawValue == UUID {
    self.appendInterpolation(raw: id.rawValue.uuidString)
  }

  mutating func appendInterpolation<M: AltModel>(table model: M.Type) {
    self.appendInterpolation(raw: model.tableName)
  }

  mutating func appendInterpolation(col: String) {
    self.appendInterpolation(raw: col)
  }
}

extension Db {
  private typealias Token = Alt.Token
  private typealias TokenScope = Alt.TokenScope

  static func live(db: Database) -> Db {
    Db(

      createToken: { token in
        let pg = db as! SQLDatabase
        return pg.raw(
          """
          INSERT INTO \(table: Token.self)
          (
            \(col: Token[.id]),
            \(col: Token[.value]),
            \(col: Token[.description]),
            \(col: Token[.createdAt])
          ) VALUES (
            '\(id: token.id)',
            '\(id: token.value)',
            '\(raw: token.description)',
            current_timestamp
          )
          """
        ).all().map { _ in }
      },

      getTokenByValue: { tokenValue in
        let pg = db as! SQLDatabase
        return pg.raw(
          """
          SELECT * FROM \(table: Token.self)
          WHERE "\(col: Token[.value])" = '\(id: tokenValue)'
          """
        ).all().map { rows -> Alt.Token in
          let row = rows.first!
          return try! row.decode(Alt.Token.self)
        }.flatMap { token in
          try! Current.db.getTokenScopes(token.id).map { scopes in
            (token, scopes)
          }
        }.map { (token, scopes) in
          token.scopes = .loaded(scopes)
          return token
        }
      },

      createTokenScope: { scope in
        let pg = db as! SQLDatabase
        return pg.raw(
          """
          INSERT INTO \(table: TokenScope.self)
          (
            \(col: TokenScope[.id]),
            \(col: TokenScope[.tokenId]),
            \(col: TokenScope[.scope]),
            \(col: TokenScope[.createdAt])
          ) VALUES (
            '\(id: scope.id)',
            '\(id: scope.tokenId)',
            '\(raw: scope.scope.rawValue)',
            current_timestamp
          )
          """
        ).all().map { _ in }
      },

      getTokenScopes: { tokenId in
        let pg = db as! SQLDatabase
        return pg.raw(
          """
          SELECT * FROM \(table: TokenScope.self)
          WHERE \(col: TokenScope[.tokenId]) = '\(id: tokenId)'
          """
        ).all().flatMapThrowing { rows in
          try rows.compactMap { row in
            try row.decode(
              model: Alt.TokenScope.self, prefix: nil, keyDecodingStrategy: .convertFromSnakeCase)
          }
        }
      }
    )
  }
}

extension Db {
  fileprivate struct Models {
    var el: EventLoop
    var tokens: [Alt.Token.Id: Alt.Token] = [:]
    var tokenScopes: [Alt.TokenScope.Id: Alt.TokenScope] = [:]

    @discardableResult
    mutating func add<M: AltModel>(
      _ model: M,
      _ keyPath: WritableKeyPath<Self, [M.IdValue: M]>
    ) -> Future<Void> {
      self[keyPath: keyPath][model.id] = model
      return el.makeSucceededFuture(())
    }
  }

  static func mock(el: EventLoop) -> Db {
    var models = Models(el: el)

    func future<T>(_ model: T) -> Future<T> {
      el.makeSucceededFuture(model)
    }

    return Db(

      createToken: { models.add($0, \.tokens) },

      getTokenByValue: { tokenValue in
        for token in models.tokens.values {
          if token.value == tokenValue {
            return future(token)
          }
        }
        throw Abort(.notFound)
      },

      createTokenScope: { models.add($0, \.tokenScopes) },

      getTokenScopes: { tokenId in
        future(
          models.tokenScopes.values.filter { $0.tokenId == tokenId }
        )
      }
    )
  }
}
