import Foundation
import SQLKit

struct ProductServing: Codable {
    let id: UUID
    let name: String
    let quantityUnit: QuantityUnit
    let quantityValue: Int
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case quantityUnit = "quantity_unit"
        case quantityValue = "quantity_value"
    }
}

extension ProductServing: SQLModel {
    static let tableName = "product_serving"

    static let columns: [String] = CodingKeys.allCases.map(\.rawValue)
    static let columnsLiteral = columns.joined(separator: ", ")
    
    func insert(into sql: SQLDatabase) async throws {
        try await sql.raw("""
        INSERT INTO \(raw: Self.tableName) (\(raw: ProductServing.columnsLiteral))
        VALUES (\(bind: id), \(bind: name), \(bind: quantityUnit.rawValue), \(bind: quantityValue))
        """).run()
    }
    
    static func queryAll(for id: UUID, using sql: SQLDatabase) async throws -> [ProductServing] {
        let rows = try await sql.raw("""
            SELECT *
            FROM "\(raw: ProductServing.tableName)"
            WHERE "id" = \(bind: id)
            """)
            .all()
        return try rows.map { try $0.decode(model: ProductServing.self) }
    }
}
