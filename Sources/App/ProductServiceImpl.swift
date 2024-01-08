import Foundation
import PostgresNIO
import FluentKit
import FluentSQL
import Vapor
import SQLiteNIO
import PostgresKit

struct ProductServiceImpl: APIProtocol {
    
    let logger: Logger
    let databaseProvider: Databases
    
    private let productColumns = Product.prefixedColumnsLiteral()
    private let nutrimentsColumns = ProductNutriments.prefixedColumnsLiteral()
    
    private enum Constants {
        static var pageSize: Int { 20 }
    }
    
    private var database: Database? {
        databaseProvider.database(logger: logger, on: databaseProvider.eventLoopGroup.any())
    }
    
    private var sqlDatabase: SQLDatabase? {
        if let database = database as? PostgresDatabase {
            return database.sql()
        }
        if let database = database as? SQLiteDatabase {
            return database.sql()
        }
        return nil
    }
    
    func getProductByID(_ input: Operations.getProductByID.Input) async throws -> Operations.getProductByID.Output {
        guard let id = UUID(uuidString: input.path.productID) else {
            logger.log(level: .critical, .init(stringLiteral: "Invalid UUID"))
            return .badRequest(.init())
        }
        guard let sqlDatabase else {
            throw Abort(.internalServerError, reason: "Database not supported.")
        }
                
        guard let row = try await sqlDatabase.raw("""
                SELECT \(raw: productColumns), \(raw: nutrimentsColumns)
                FROM "\(raw: Product.tableName)"
                JOIN "\(raw: ProductNutriments.tableName)" ON "\(raw: Product.tableName)"."id" = "\(raw: ProductNutriments.tableName)"."id"
                JOIN "\(raw: ProductName.tableName)" ON "\(raw: Product.tableName)"."id" = "\(raw: ProductName.tableName)"."id"
                WHERE "\(raw: Product.tableName)"."id" = \(bind: id)
                """)
            .first() else {
            return .notFound(.init())
        }
        
        let product = try row.decodeToSQLModel(Product.self, usePrefix: true)
        let nutriments = try row.decodeToSQLModel(ProductNutriments.self, usePrefix: true)
        
        let productNames = try await ProductName.queryAll(for: product.id, using: sqlDatabase)
        let productBrands = try await ProductBrand.queryAll(for: product.id, using: sqlDatabase)
        let productServings = try await ProductServing.queryAll(for: product.id, using: sqlDatabase)
        
        let info = ProductInfo(product: product,
            productNutriments: nutriments,
            productNames: productNames,
            productBrands: productBrands,
            productServings: productServings)
        return .ok(.init(body: .json(try ProductMappingHelper.convertToDto(info))))
    }
    
    func addProduct(_ input: Operations.addProduct.Input) async throws -> Operations.addProduct.Output {
        switch input.body {
        case .json(let productDto):
            guard let database else {
                throw Abort(.internalServerError, reason: "Missing database.")
            }
            do {
                try await addProduct(productDto, database: database)
            } catch let error as AbortError where error.status == .conflict {
                return .conflict(.init())
            }
            return .ok(.init())
        case .none:
            throw Abort(.unsupportedMediaType)
        }
    }
    
    func searchByText(_ input: Operations.searchByText.Input) async throws -> Operations.searchByText.Output {
        let searchText = input.query.text.lowercased()
        let page = input.query.page ?? 0
        
        let fetchedProducts = try await productSearch(searchText, page: page)
        
        let products = try fetchedProducts.map { try ProductMappingHelper.convertToDto($0) }
        return .ok(.init(body: .json(.init(page: page, array: products))))
    }
    
    private func addProduct(_ productDto: Components.Schemas.Product, database: Database) async throws {
//        try await database.transaction { database in
            try await addProductTransaction(productDto, database: database)
//        }
    }
    
    private func addProductTransaction(_ productDto: Components.Schemas.Product, database: Database) async throws {
//        guard database.inTransaction else {
//            throw Abort(.internalServerError, reason: "Called addProductTransaction but the passed database is not in transaction")
//        }
        guard let sqlDatabase else {
            throw Abort(.internalServerError, reason: "Database not supported.")
        }
        let product = try ProductMappingHelper.convertFromDto(productDto)
        do {
            try await product.save(on: sqlDatabase)
        } catch let error as DatabaseError where error.isConstraintFailure {
            throw Abort(.conflict)
        }
        
        let nutriments = ProductNutriments(from: productDto.nutriments, id: product.id)
        try await nutriments.save(on: sqlDatabase)

        let productNames: [ProductName] = productDto.names.compactMap { .init(from: $0, id: product.id) }
        for productName in productNames {
            try await productName.save(on: sqlDatabase)
        }
        
        if let productDtoBrands = productDto.brands {
            let productBrands: [ProductBrand] = productDtoBrands.compactMap { .init(from: $0, id: product.id) }
            for productBrand in productBrands {
                try await productBrand.insert(into: sqlDatabase)
            }
        }
        
        if let productDtoServings = productDto.servings {
            let productServings: [ProductServing] = productDtoServings.map { .init(from: $0, id: product.id) }
            for productServing in productServings {
                try await productServing.insert(into: sqlDatabase)
            }
        }
    }
    
    /// Performs a Product search for a given `searchText` and `page`.
    ///
    /// All the needed relations of the `Product` model are already lazy loaded.
    /// - Warning: As of Vapor Fluent 4.8.0 it's not possible to perform a `GROUP BY` which is needed for this query as we otherwise end up with duplicates or the limit breaks if we filter them out. Therefore, we rely for this on a raw SQL query for now.
    private func productSearch(_ searchText: String, page: Int) async throws -> [ProductInfo] {
        guard let database, let sql = database as? SQLDatabase else {
            throw Abort(.internalServerError, reason: "Database not supported.")
        }

        let searchTextPattern = "%" + searchText.lowercased() + "%"
        let limit = Constants.pageSize
        let offset = page * Constants.pageSize
        
        let rawQuery = SQLQueryString("""
            SELECT \(raw: productColumns), \(raw: nutrimentsColumns)
            FROM \(raw: Product.tableName)
            JOIN "\(raw: ProductNutriments.tableName)" ON "\(raw: Product.tableName)"."id" = "\(raw: ProductNutriments.tableName)"."id"
            INNER JOIN \(raw: ProductName.tableName) ON \(raw: Product.tableName).id = \(raw: ProductName.tableName).id
            LEFT JOIN \(raw: ProductBrand.tableName) ON \(raw: Product.tableName).id = \(raw: ProductBrand.tableName).id
            WHERE \(raw: ProductName.tableName).name_lowercase LIKE \(bind: searchTextPattern)
            OR \(raw: ProductBrand.tableName).brand_lowercase LIKE \(bind: searchTextPattern)
            GROUP BY \(raw: Product.tableName).id, \(raw: ProductNutriments.tableName).id
            LIMIT \(bind: limit) OFFSET \(bind: offset)
            """)
        
        let productRows = try await sql.raw(rawQuery).all()
        
        let productInfos = try await productRows.asyncMap { row in
            let product = try row.decodeToSQLModel(Product.self, usePrefix: true)
            let nutriments = try row.decodeToSQLModel(ProductNutriments.self, usePrefix: true)
            let productNames = try await ProductName.queryAll(for: product.id, using: sql)
            let productBrands = try await ProductBrand.queryAll(for: product.id, using: sql)
            let productServings = try await ProductServing.queryAll(for: product.id, using: sql)
            return ProductInfo(product: product,
                               productNutriments: nutriments,
                               productNames: productNames,
                               productBrands: productBrands,
                               productServings: productServings)
        }
        return productInfos
    }
}

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}

extension SQLRow {
    func decodeToSQLModel<D: SQLModel & Decodable>(_ type: D.Type, usePrefix: Bool) throws -> D {
        try decode(model: type, prefix: usePrefix ? "\(type.tableName)_" : nil, keyDecodingStrategy: .useDefaultKeys)
    }
}
