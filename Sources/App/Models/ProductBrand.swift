import Fluent
import Foundation
import Vapor

final class ProductBrand: Model {
    static let schema = "product_brand"
    
    final class Identifier: Fields, Hashable {
        
        @Field(key: .id)
        var id: UUID?
        
        @Field(key: "language_code")
        var languageCode: String
        
        init() {}
        
        init(id: UUID?, languageCode: String) {
            self.id = id
            self.languageCode = languageCode
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(languageCode)
        }
        
        static func == (lhs: Identifier, rhs: Identifier) -> Bool {
            lhs.id == rhs.id && lhs.languageCode == rhs.languageCode
        }
    }

    @CompositeID()
    var id: Identifier?

    @Field(key: "brand")
    var brand: String

    @Field(key: "brand_lowercase")
    var brandLowercase: String

    @Parent(key: "id")
    var product: Product

    init() {}

    init(id: UUID?, languageCode: String, brand: String) {
        self.id = .init(id: id, languageCode: languageCode)
        self.brand = brand
        self.brandLowercase = brand.lowercased()
    }
}
