import NonEmpty

extension NonEmpty where Collection == [Int] {
  var array: [Int] {
    return [self.first] + self.dropFirst()
  }
}
