struct Auth {
  var userCan: (User?, Scope) -> Bool
}

extension Auth {
  static let live = Auth(userCan: { user, scope in
    guard let user = user, user.hasScope(scope) else {
      return false
    }
    return true
  })
}

extension Auth {
  static let mockWithAllScopes = Auth(userCan: { _, _ in true })
  static let mockUnAuthed = Auth(userCan: { _, _ in false })
}
