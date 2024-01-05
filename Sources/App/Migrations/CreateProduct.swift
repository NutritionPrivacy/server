import Fluent

struct CreateProduct: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("product")
            .field("id", .uuid, .identifier(auto: false))
            .field("barcode", .int)
            .field("quantity_unit", .string, .required)
            .field("quantity_value", .int, .required)
            .field("source", .string, .required)
            .field("verified", .bool, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("product").delete()
    }
}
