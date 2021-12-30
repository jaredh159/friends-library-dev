import NonEmpty

extension NonEmpty {
  enum InitError: Error {
    case emptyCollection
  }
}

extension NonEmpty where Collection == [Int] {
  var array: [Int] {
    return [self.first] + self.dropFirst()
  }
}

extension NonEmpty where Collection: RangeReplaceableCollection {
  static func fromArray(_ collection: Collection) throws -> NonEmpty<Collection> {
    guard let first = collection.first else { throw InitError.emptyCollection }
    return NonEmpty<Collection>(first) + collection.dropFirst()
  }
}
