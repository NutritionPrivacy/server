import Foundation

protocol SQLModel {
    static var tableName: String { get }
    static var columns: [String] { get }
}

extension SQLModel {
    static func prefixedColumnsLiteral() -> String {
        let prefix = tableName
        return columns.map { "\(prefix).\($0) as \(prefix)_\($0)" }.joined(separator: ", ")
    }
}
