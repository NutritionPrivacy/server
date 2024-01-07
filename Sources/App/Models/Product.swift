import Foundation
import SQLKit

struct Product: Codable {
    let id: UUID
    let barcode: Int?
    let quantityUnit: QuantityUnit
    let quantityValue: Int
    let source: String
    let verified: Bool
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case barcode
        case quantityUnit = "quantity_unit"
        case quantityValue = "quantity_value"
        case source
        case verified
    }
}

extension Product: SQLModel {
    static let tableName = "product"
    
    static let columnsLiteral = columns.joined(separator: ", ")
    static let columns: [String] = CodingKeys.allCases.map(\.rawValue)

    func save(on database: SQLDatabase) async throws {
        try await database.raw("""
        INSERT INTO \(raw: Product.tableName) (
        \(raw: Self.columnsLiteral)
        ) VALUES (\(bind: id), \(bind: barcode), \(bind: quantityUnit.rawValue), \(bind: quantityValue), \(bind: source), \(bind: verified))
        """).run()
    }
}
