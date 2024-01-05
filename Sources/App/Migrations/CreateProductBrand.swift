import Foundation
import Fluent

struct CreateProductBrand: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("product_brand")
            .field("id", .uuid, .references("product", "id", onDelete: .cascade))
            .field("brand", .string, .required)
            .field("brand_lowercase", .string, .required)
            .field("language_code", .string, .required)
            .compositeIdentifier(over: .string("id"), .string("language_code"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("product_brand").delete()
    }
}
