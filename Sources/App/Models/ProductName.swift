import Fluent
import Foundation
import Vapor

final class ProductName: Model {
    static let schema = "product_name"
    
    final class Identifier: Fields, Hashable {
        
        @Field(key: .id)
        var id: UUID?
        
        @Field(key: "language_code")
        var languageCode: String
        
        @Parent(key: "id")
        var product: Product
        
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

    @Field(key: "name")
    var name: String

    @Field(key: "name_lowercase")
    var nameLowercase: String

    @Parent(key: "id")
    var product: Product

    init() {}

    init(id: UUID?, languageCode: String, name: String) {
        self.id = .init(id: id, languageCode: languageCode)
        self.name = name
        self.nameLowercase = name.lowercased()
    }
}
