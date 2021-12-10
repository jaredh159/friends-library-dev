import Fluent
import FluentSQL
import Tagged
import Vapor

struct Db {
  var createToken: (Token) -> Future<Void>
  var getTokenByValue: (Token.Value) throws -> Future<Token>
  var createTokenScope: (TokenScope) -> Future<Void>
  var getTokenScopes: (Token.Id) throws -> Future<[TokenScope]>
}

extension Db {
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
        ).all().map { rows -> Token in
          let row = rows.first!
          return try! row.decode(Token.self)
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
              model: TokenScope.self, prefix: nil, keyDecodingStrategy: .convertFromSnakeCase)
          }
        }
      }
    )
  }
}

extension Db {
  fileprivate struct Models {
    var el: EventLoop
    var tokens: [Token.Id: Token] = [:]
    var tokenScopes: [TokenScope.Id: TokenScope] = [:]

    @discardableResult
    mutating func add<M: AppModel>(
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
