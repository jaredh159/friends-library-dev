import Fluent
import Foundation
import Graphiti
import Vapor

let AppSchema = try! Graphiti.Schema<Resolver, Request> {
  Scalar(UUID.self)
  DateScalar(formatter: ISO8601DateFormatter())

  Enum(EditionType.self)
  Enum(Lang.self)

  Enum(Download.Format.self)
  Enum(Download.AudioQuality.self)
  Enum(Download.DownloadSource.self)
  Enum(Order.PrintJobStatus.self)
  Enum(Order.ShippingLevel.self)
  Enum(Order.OrderSource.self)

  Type(Order.self) {
    Field("id", at: \.id)
    Field("paymentId", at: \.paymentId)
    Field("printJobStatus", at: \.printJobStatus)
    Field("printJobId", at: \.printJobId)
    Field("amount", at: \.amount)
    Field("shipping", at: \.shipping)
    Field("taxes", at: \.taxes)
    Field("ccFeeOffset", at: \.ccFeeOffset)
    Field("shippingLevel", at: \.shippingLevel)
    Field("email", at: \.email)
    Field("addressName", at: \.addressName)
    Field("addressStreet", at: \.addressStreet)
    Field("addressStreet2", at: \.addressStreet2)
    Field("addressCity", at: \.addressCity)
    Field("addressState", at: \.addressState)
    Field("addressZip", at: \.addressZip)
    Field("addressCountry", at: \.addressCountry)
    Field("lang", at: \.lang)
    Field("source", at: \.source)
    Field("items", with: \.$items)
  }

  Type(OrderItem.self) {
    Field("title", at: \.title)
    Field("documentId", at: \.documentId)
    Field("editionType", at: \.editionType)
    Field("quantity", at: \.quantity)
    Field("unitPrice", at: \.unitPrice)
    Field("order", with: \.$order)
  }

  Input(UpdateOrderInput.self) {
    InputField("id", at: \.id)
    InputField("printJobStatus", at: \.printJobStatus)
    InputField("printJobId", at: \.printJobId)
  }

  Input(CreateOrderInput.Item.self) {
    InputField("title", at: \.title)
    InputField("documentId", at: \.documentId)
    InputField("editionType", at: \.editionType)
    InputField("quantity", at: \.quantity)
    InputField("unitPrice", at: \.unitPrice)
  }

  Input(CreateOrderInput.self) {
    InputField("paymentId", at: \.paymentId)
    InputField("printJobStatus", at: \.printJobStatus)
    InputField("printJobId", at: \.printJobId)
    InputField("amount", at: \.amount)
    InputField("shipping", at: \.shipping)
    InputField("taxes", at: \.taxes)
    InputField("ccFeeOffset", at: \.ccFeeOffset)
    InputField("shippingLevel", at: \.shippingLevel)
    InputField("email", at: \.email)
    InputField("addressName", at: \.addressName)
    InputField("addressStreet", at: \.addressStreet)
    InputField("addressStreet2", at: \.addressStreet2)
    InputField("addressCity", at: \.addressCity)
    InputField("addressState", at: \.addressState)
    InputField("addressZip", at: \.addressZip)
    InputField("addressCountry", at: \.addressCountry)
    InputField("lang", at: \.lang)
    InputField("source", at: \.source)
    InputField("items", at: \.items)
  }

  Type(Download.self) {
    Field("id", at: \.id)
    Field("documentId", at: \.documentId)
    Field("editionType", at: \.editionType)
    Field("format", at: \.format)
    Field("source", at: \.source)
    Field("isMobile", at: \.isMobile)
    Field("audioQuality", at: \.audioQuality)
    Field("audioPartNumber", at: \.audioPartNumber)
    Field("userAgent", at: \.userAgent)
    Field("os", at: \.os)
    Field("browser", at: \.browser)
    Field("platform", at: \.platform)
    Field("referrer", at: \.referrer)
    Field("ip", at: \.ip)
    Field("city", at: \.city)
    Field("region", at: \.region)
    Field("postalCode", at: \.postalCode)
    Field("country", at: \.country)
    Field("latitude", at: \.latitude)
    Field("longitude", at: \.longitude)
  }

  Query {
    Field("getOrder", at: Resolver.getOrder) {
      Argument("id", at: \.id)
    }
  }

  Mutation {
    Field("createDownload", at: Resolver.createDownload) {
      Argument("documentId", at: \.documentId)
      Argument("editionType", at: \.editionType)
      Argument("format", at: \.format)
      Argument("source", at: \.source)
      Argument("isMobile", at: \.isMobile)
      Argument("audioQuality", at: \.audioQuality)
      Argument("audioPartNumber", at: \.audioPartNumber)
      Argument("userAgent", at: \.userAgent)
      Argument("os", at: \.os)
      Argument("browser", at: \.browser)
      Argument("platform", at: \.platform)
      Argument("referrer", at: \.referrer)
      Argument("ip", at: \.ip)
      Argument("city", at: \.city)
      Argument("region", at: \.region)
      Argument("postalCode", at: \.postalCode)
      Argument("country", at: \.country)
      Argument("latitude", at: \.latitude)
      Argument("longitude", at: \.longitude)
    }

    Field("createOrder", at: Resolver.createOrder) {
      Argument("input", at: \.input)
    }

    Field("updateOrder", at: Resolver.updateOrder) {
      Argument("input", at: \.input)
    }

    Field("updateOrders", at: Resolver.updateOrders) {
      Argument("input", at: \.input)
    }
  }

  Types(OrderItem.self)
}
