import Fluent
import Vapor

struct Db {
  var createToken: (Token) -> Future<Token>
  var getTokenByValue: (Token.Value) throws -> Future<Token>
  var createTokenScope: (TokenScope) -> Future<TokenScope>
}

extension Db {
  static func live(db: Database) -> Db {
    Db(

      createToken: { token in
        print("LIVE!!!")
        return token.create(on: db).map { token }
      },

      getTokenByValue: { tokenValue in
        print("LIVE!!!")
        return Token.query(on: db)
          .filter(\.$value == tokenValue)
          .with(\.$scopes)
          .first()
          .unwrap(or: Abort(.notFound))
      },

      createTokenScope: { scope in
        print("LIVE!!!")
        return scope.create(on: db).map { scope }
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
    mutating func add<M: FlpModel>(
      _ model: M,
      _ keyPath: WritableKeyPath<Self, [M.IDValue: M]>
    ) -> Future<M> {
      if model.id == nil {
        print("set the ID")
        model.id = M.randomId() as? M.IDValue
      } else {
        print("already has one!")
      }
      self[keyPath: keyPath][model.id!] = model
      return el.makeSucceededFuture(model)
    }
  }

  static func mock(el: EventLoop) -> Db {
    var models = Models(el: el)

    return Db(

      createToken: { models.add($0, \.tokens) },

      getTokenByValue: { tokenValue in
        print(models.tokens.values, "jared")
        for token in models.tokens.values {
          if token.value == tokenValue {
            print(token.id, "TOKEN iD")
            // throw Abort(.notFound)
            // token.$scopes.idValue = token.id!
            // token.$scopes.value = Array(models.tokenScopes.values)
            // .filter { scope in
            //   scope.$token.id == token.id
            // }

            return el.makeSucceededFuture(token)
          }
        }
        throw Abort(.notFound)
      },

      createTokenScope: { models.add($0, \.tokenScopes) }
    )
  }
}
