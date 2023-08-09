import Foundation
import Graphiti

struct AudioFiles: Encodable {
  struct Qualities: Encodable {
    let hq: DownloadableFile
    let lq: DownloadableFile

    var all: [DownloadableFile] {
      [hq, lq]
    }
  }

  let podcast: Qualities
  let mp3s: Qualities
  let m4b: Qualities

  var all: [DownloadableFile] {
    podcast.all + mp3s.all + m4b.all
  }
}

extension Audio {

  var files: AudioFiles {
    let edition = edition.require()
    return AudioFiles(
      podcast: .init(
        hq: .init(edition: edition, format: .audio(.podcast(.high))),
        lq: .init(edition: edition, format: .audio(.podcast(.low)))
      ),
      mp3s: .init(
        hq: .init(edition: edition, format: .audio(.mp3s(.high))),
        lq: .init(edition: edition, format: .audio(.mp3s(.low)))
      ),
      m4b: .init(
        hq: .init(edition: edition, format: .audio(.m4b(.high))),
        lq: .init(edition: edition, format: .audio(.m4b(.low)))
      )
    )
  }
}

// extensions

extension AppSchema {
  static var AudioFileQualitiesType: AppType<AudioFiles.Qualities> {
    Type(AudioFiles.Qualities.self, as: "AudioFileQualities") {
      Field("hq", at: \.hq)
      Field("lq", at: \.lq)
    }
  }

  static var AudioFilesType: AppType<AudioFiles> {
    Type(AudioFiles.self) {
      Field("podcast", at: \.podcast)
      Field("mp3s", at: \.mp3s)
      Field("m4b", at: \.m4b)
    }
  }
}
