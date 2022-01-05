import FluentSQL
import Vapor

enum DbError: Error {
  case notFound
  case decodingFailed
  case nonUniformBulkInsertInput
  case emptyBulkInsertInput
}
