import DuetSQL
import Foundation
import NIO
import Tagged
import Vapor

extension Model {
  static var isPreloaded: Bool {
    switch tableName {
      case Friend.tableName,
           FriendQuote.tableName,
           FriendResidence.tableName,
           FriendResidenceDuration.tableName,
           Document.tableName,
           DocumentTag.tableName,
           RelatedDocument.tableName,
           Edition.tableName,
           EditionImpression.tableName,
           EditionChapter.tableName,
           Audio.tableName,
           AudioPart.tableName,
           Isbn.tableName:
        return true
      default:
        return false
    }
  }
}

enum ModelError: Error {
  case invalidEntity
}

protocol ApiModel: Model, Equatable {
  var isValid: Bool { get }
}

extension Children {
  func require(file: StaticString = #file, line: UInt = #line) -> [C] {
    guard let models = try? models else {
      invariant("Required children [\(C.self)] not loaded at \(file):\(line)")
    }
    return models
  }
}

extension Parent {
  func require(file: StaticString = #file, line: UInt = #line) -> P {
    guard let model = try? model else {
      invariant("Required parent \(P.self) not loaded at \(file):\(line)")
    }
    return model
  }
}

extension OptionalParent {
  func require(file: StaticString = #file, line: UInt = #line) -> P? {
    guard case .loaded(let model) = self else {
      invariant("Required optional parent \(P.self) not loaded at \(file):\(line)")
    }
    return model
  }
}

extension OptionalChild {
  func require(file: StaticString = #file, line: UInt = #line) -> C? {
    guard case .loaded(let model) = self else {
      invariant("Required optional child \(C.self) not loaded at \(file):\(line)")
    }
    return model
  }
}

protocol EntityClient: DuetSQL.Client {
  func entities() async throws -> PreloadedEntities
}
