import Foundation
import SQLKit

struct ProductBrand: Codable {
    let id: UUID
    let languageCode: String
    let brand: String
    let brandLowercase: String
    
    init(id: UUID, languageCode: String, brand: String) {
        self.id = id
        self.languageCode = languageCode
        self.brand = brand
        self.brandLowercase = brand.lowercased()
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case languageCode = "language_code"
        case brand
        case brandLowercase = "brand_lowercase"
    }

}

extension ProductBrand: SQLModel {
    static let tableName = "product_brand"

    static let columns: [String] = CodingKeys.allCases.map(\.rawValue)
    static let columnsLiteral = columns.joined(separator: ", ")
    
    func insert(into sql: SQLDatabase) async throws {
        try await sql.raw("""
        INSERT INTO \(raw: Self.tableName) (\(raw: ProductBrand.columnsLiteral))
        VALUES (\(bind: id), \(bind: languageCode), \(bind: brand), \(bind: brandLowercase))
        """).run()
    }
    
    static func queryAll(for id: UUID, using sql: SQLDatabase) async throws -> [ProductBrand] {
        let rows = try await sql.raw("""
            SELECT *
            FROM "\(raw: ProductBrand.tableName)"
            WHERE "id" = \(bind: id)
            """)
            .all()
        return try rows.map { try $0.decode(model: ProductBrand.self) }
    }
}
