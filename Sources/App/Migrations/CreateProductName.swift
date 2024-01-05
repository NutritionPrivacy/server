import Foundation
import Fluent

struct CreateProductName: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("product_name")
            .field("id", .uuid, .references("product", "id", onDelete: .cascade))
            .field("name", .string, .required)
            .field("name_lowercase", .string, .required)
            .field("language_code", .string, .required)
            .compositeIdentifier(over: .string("id"), .string("language_code"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("product_name").delete()
    }
}
