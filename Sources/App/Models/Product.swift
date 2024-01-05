import Fluent
import Foundation
import Vapor

final class Product: Model {
    static let schema = "product"

    @ID(key: .id)
    var id: UUID?

    @OptionalField(key: "barcode")
    var barcode: Int?

    @Field(key: "quantity_unit")
    var quantityUnit: QuantityUnit

    @Field(key: "quantity_value")
    var quantityValue: Int

    @Field(key: "source")
    var source: String

    @Field(key: "verified")
    var verified: Bool

    @Parent(key: "id")
    var nutriments: ProductNutriments
    
    @Children(for: \.$product)
    var productNames: [ProductName]
    
    @Children(for: \.$product)
    var productBrands: [ProductBrand]
    
    @Children(for: \.$product)
    var productServings: [ProductServing]

    init() {}

    init(id: UUID? = nil,
         barcode: Int?,
         quantityUnit: QuantityUnit,
         quantityValue: Int,
         source: String,
         verified: Bool
    ) {
        self.id = id
        self.barcode = barcode
        self.quantityUnit = quantityUnit
        self.quantityValue = quantityValue
        self.source = source
        self.verified = verified
    }
}

enum QuantityUnit: String, Codable {
    case ml = "ml"
    case l = "l"
    case microgram = "microgram"
    case mg = "mg"
    case g = "g"
    case kg = "kg"
}
