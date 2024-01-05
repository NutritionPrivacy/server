import Foundation
import Fluent

struct CreateProductServing: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("product_serving")
            .field("id", .uuid, .references("product", "id", onDelete: .cascade), .identifier(auto: false))
            .field("name", .string, .required)
            .field("quantity_value", .int, .required)
            .field("quantity_unit", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("product_serving").delete()
    }
}
