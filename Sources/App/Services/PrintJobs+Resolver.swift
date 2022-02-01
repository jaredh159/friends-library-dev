import Graphiti
import NonEmpty
import Vapor

extension Resolver {
  func getPrintJobExploratoryMetadata(
    req: Req,
    args: InputArgs<AppSchema.GetPrintJobExploratoryMetadataInput>
  ) throws -> Future<PrintJobs.ExploratoryMetadata> {
    let items = try args.input.items
      .map { inputItem in
        PrintJobs.ExploratoryItem(
          volumes: try NonEmpty<[Int]>.fromArray(inputItem.volumes),
          printSize: inputItem.printSize,
          quantity: inputItem.quantity
        )
      }
    return future(of: PrintJobs.ExploratoryMetadata.self, on: req.eventLoop) {
      try await PrintJobs.getExploratoryMetadata(
        for: items,
        shippedTo: args.input.address.shippingAddress
      )
    }
  }
}

extension AppSchema {
  struct PrintJobExploratoryItemInput: Codable {
    var volumes: [Int]
    var printSize: PrintSize
    var quantity: Int
  }

  struct GetPrintJobExploratoryMetadataInput: Codable {
    var items: [PrintJobExploratoryItemInput]
    var address: ShippingAddressInput
  }

  static var getPrintJobExploratoryMetadata: AppField<
    PrintJobs.ExploratoryMetadata,
    InputArgs<GetPrintJobExploratoryMetadataInput>
  > {
    Field("getPrintJobExploratoryMetadata", at: Resolver.getPrintJobExploratoryMetadata) {
      Argument("input", at: \.input)
    }
  }

  static var PrintJobExploratoryMetadataType: AppType<PrintJobs.ExploratoryMetadata> {
    Type(PrintJobs.ExploratoryMetadata.self, as: "PrintJobExploratoryMetadata") {
      Field("shippingLevel", at: \.shippingLevel)
      Field("shippingInCents", at: \.shipping.rawValue)
      Field("taxesInCents", at: \.taxes.rawValue)
      Field("feesInCents", at: \.fees.rawValue)
      Field("creditCardFeeOffsetInCents", at: \.creditCardFeeOffset.rawValue)
    }
  }

  static var PrintJobExploratoryItemInputType: AppInput<PrintJobExploratoryItemInput> {
    Input(PrintJobExploratoryItemInput.self) {
      InputField("volumes", at: \.volumes)
      InputField("printSize", at: \.printSize)
      InputField("quantity", at: \.quantity)
    }
  }

  static var GetPrintJobExploratoryMetadataInputType: AppInput<GetPrintJobExploratoryMetadataInput> {
    Input(GetPrintJobExploratoryMetadataInput.self) {
      InputField("items", at: \.items)
      InputField("address", at: \.address)
    }
  }
}
