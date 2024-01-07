import Foundation
import SQLKit

struct ProductName: Codable {
    let id: UUID
    let languageCode: String
    let name: String
    let nameLowercase: String
    
    init(id: UUID, languageCode: String, name: String) {
        self.id = id
        self.languageCode = languageCode
        self.name = name
        self.nameLowercase = name.lowercased()
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case languageCode = "language_code"
        case name
        case nameLowercase = "name_lowercase"
    }

}

extension ProductName: SQLModel {
    static let tableName = "product_name"
    
    static let columnsLiteral = columns.joined(separator: ", ")
    static let columns: [String] = CodingKeys.allCases.map(\.rawValue)

    func save(on database: SQLDatabase) async throws {
        try await database.raw("""
        INSERT INTO \(raw: Self.tableName) (\(raw: Self.columnsLiteral))
        VALUES (\(bind: id), \(bind: languageCode), \(bind: name), \(bind: nameLowercase))
        """).run()
    }
    
    static func queryAll(for id: UUID, using sql: SQLDatabase) async throws -> [ProductName] {
        let productNameRows = try await sql.raw("""
            SELECT *
            FROM "\(raw: ProductName.tableName)"
            WHERE "id" = \(bind: id)
            """)
            .all()
        return try productNameRows.map { try $0.decode(model: ProductName.self) }
    }
}
