import Foundation

final class DocumentTagModel: Codable {
  var id: Id
  var slug: DocumentTag
  var createdAt = Current.date()

  init(id: Id = .init(), slug: DocumentTag) {
    self.id = id
    self.slug = slug
  }
}
