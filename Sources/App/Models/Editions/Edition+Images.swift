import Foundation
import Graphiti
import Vapor

extension Edition {
  struct Images: Codable {
    struct Image: Codable {
      let width: Int
      let height: Int
      let url: URL
    }

    struct Square: Codable {
      let w45: Image
      let w90: Image
      let w180: Image
      let w270: Image
      let w300: Image
      let w450: Image
      let w600: Image
      let w750: Image
      let w900: Image
      let w1150: Image
      let w1400: Image
    }

    struct ThreeD: Codable {
      let w55: Image
      let w110: Image
      let w250: Image
      let w400: Image
      let w550: Image
      let w700: Image
      let w850: Image
      let w1000: Image
      let w1120: Image
    }

    let square: Square
    let threeD: ThreeD
  }

  var images: Images {
    let path = "\(Env.CLOUD_STORAGE_BUCKET_URL)/\(directoryPath)/images"
    return Images(
      square: .init(
        w45: squareImage(45, path),
        w90: squareImage(90, path),
        w180: squareImage(180, path),
        w270: squareImage(270, path),
        w300: squareImage(300, path),
        w450: squareImage(450, path),
        w600: squareImage(600, path),
        w750: squareImage(750, path),
        w900: squareImage(900, path),
        w1150: squareImage(1150, path),
        w1400: squareImage(1400, path)
      ),
      threeD: .init(
        w55: threeDImage(55, path),
        w110: threeDImage(110, path),
        w250: threeDImage(250, path),
        w400: threeDImage(400, path),
        w550: threeDImage(550, path),
        w700: threeDImage(700, path),
        w850: threeDImage(850, path),
        w1000: threeDImage(1000, path),
        w1120: threeDImage(1120, path)
      )
    )
  }
}

// extensions

extension AppSchema {
  static var EditionImageType: AppType<Edition.Images.Image> {
    Type(Edition.Images.Image.self, as: "EditionImage") {
      Field("width", at: \.width)
      Field("height", at: \.height)
      Field("url", at: \.url.absoluteString)
    }
  }

  static var EditionSquareImagesType: AppType<Edition.Images.Square> {
    Type(Edition.Images.Square.self, as: "EditionSquareImages") {
      Field("w45", at: \.w45)
      Field("w90", at: \.w90)
      Field("w180", at: \.w180)
      Field("w270", at: \.w270)
      Field("w300", at: \.w300)
      Field("w450", at: \.w450)
      Field("w600", at: \.w600)
      Field("w750", at: \.w750)
      Field("w900", at: \.w900)
      Field("w1150", at: \.w1150)
      Field("w1400", at: \.w1400)
    }
  }

  static var EditionThreeDImagesType: AppType<Edition.Images.ThreeD> {
    Type(Edition.Images.ThreeD.self, as: "EditionThreeDImages") {
      Field("w55", at: \.w55)
      Field("w110", at: \.w110)
      Field("w250", at: \.w250)
      Field("w400", at: \.w400)
      Field("w550", at: \.w550)
      Field("w700", at: \.w700)
      Field("w850", at: \.w850)
      Field("w1000", at: \.w1000)
      Field("w1120", at: \.w1120)
    }
  }

  static var EditionImagesType: AppType<Edition.Images> {
    Type(Edition.Images.self, as: "EditionImages") {
      Field("square", at: \.square)
      Field("threeD", at: \.threeD)
    }
  }
}

// helpers

private let threeDImageAspectRatio: Double = 1120.0 / 1640.0

private func squareImage(_ size: Int, _ path: String) -> Edition.Images.Image {
  .init(
    width: size,
    height: size,
    url: URL(string: "\(path)/cover--\(size)x\(size).png")!
  )
}

private func threeDImage(_ width: Int, _ path: String) -> Edition.Images.Image {
  .init(
    width: width,
    height: Int((Double(width) / threeDImageAspectRatio).rounded(.down)),
    url: URL(string: "\(path)/cover-3d--w\(width).png")!
  )
}
