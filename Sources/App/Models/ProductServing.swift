import Fluent
import Foundation
import Vapor

final class ProductServing: Model {
    static let schema = "product_serving"

    final class Identifier: Fields, Hashable {
        
        @Field(key: .id)
        var id: UUID?
        
        @Field(key: "name")
        var name: String
        
        init() {}
        
        init(id: UUID?, name: String) {
            self.id = id
            self.name = name
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(name)
        }
        
        static func == (lhs: Identifier, rhs: Identifier) -> Bool {
            lhs.id == rhs.id && lhs.name == rhs.name
        }
    }

    @CompositeID()
    var id: Identifier?

    @Field(key: "quantity_unit")
    var quantityUnit: QuantityUnit

    @Field(key: "quantity_value")
    var quantityValue: Int

    @Parent(key: "id")
    var product: Product

    init() {}

    init(id: UUID?, name: String, quantityUnit: QuantityUnit, quantityValue: Int) {
        self.id = .init(id: id, name: name)
        self.quantityUnit = quantityUnit
        self.quantityValue = quantityValue
    }
}
