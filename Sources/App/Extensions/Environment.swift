import Vapor

extension Environment {
  static let PG_DUMP_PATH = get("PG_DUMP_PATH")!
  static let CLOUD_STORAGE_KEY = get("CLOUD_STORAGE_KEY")!
  static let CLOUD_STORAGE_SECRET = get("CLOUD_STORAGE_SECRET")!
  static let CLOUD_STORAGE_ENDPOINT = get("CLOUD_STORAGE_ENDPOINT")!
  static let CLOUD_STORAGE_BUCKET_URL = get("CLOUD_STORAGE_BUCKET_URL")!
  static let CLOUD_STORAGE_BUCKET = get("CLOUD_STORAGE_BUCKET")!
  static let SENDGRID_API_KEY = get("SENDGRID_API_KEY")!
  static let DATABASE_NAME = get("DATABASE_NAME")!
  static let DATABASE_USERNAME = get("DATABASE_USERNAME")!
  static let DATABASE_PASSWORD = get("DATABASE_PASSWORD")!
}
