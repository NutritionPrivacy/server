import Foundation
import PostgresNIO
import FluentKit
import FluentSQL
import Vapor

struct ProductServiceImpl: APIProtocol {
    
    let logger: Logger
    let databaseProvider: Databases
    
    private enum Constants {
        static var pageSize: Int { 20 }
    }
    
    private var database: Database? {
        databaseProvider.database(logger: logger, on: databaseProvider.eventLoopGroup.any())
    }
    
    func getProductByID(_ input: Operations.getProductByID.Input) async throws -> Operations.getProductByID.Output {
        guard let id = UUID(uuidString: input.path.productID) else {
            logger.log(level: .critical, .init(stringLiteral: "Invalid UUID"))
            return .badRequest(.init())
        }
        guard let database else {
            throw Abort(.internalServerError, reason: "Missing database.")
        }
        
        let fetchedProduct = try await Product.query(on: database)
            .with(\.$productNames)
            .with(\.$productBrands)
            .with(\.$nutriments)
            .with(\.$productServings)
            .filter(\.$id == id)
            .first()
        if let fetchedProduct {
            return .ok(.init(body: .json(ProductMappingHelper.convertToDto(fetchedProduct))))
        } else {
            return .notFound(.init())
        }
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
        
        let products = fetchedProducts.map { ProductMappingHelper.convertToDto($0) }
        return .ok(.init(body: .json(.init(page: page, array: products))))
    }
    
    private func addProduct(_ productDto: Components.Schemas.Product, database: Database) async throws {
        try await database.transaction { database in
            try await addProductTransaction(productDto, database: database)
        }
    }
    
    private func addProductTransaction(_ productDto: Components.Schemas.Product, database: Database) async throws {
        guard database.inTransaction else {
            throw Abort(.internalServerError, reason: "Called addProductTransaction but the passed database is not in transaction")
        }
        let product = try ProductMappingHelper.convertFromDto(productDto)
        do {
            try await product.save(on: database)
        } catch let error as DatabaseError where error.isConstraintFailure {
            throw Abort(.conflict)
        }
        
        let nutriments = ProductNutriments(from: productDto.nutriments)
        nutriments.id = product.id
        try await nutriments.save(on: database)
        
        let productNames: [ProductName] = productDto.names.compactMap { .init(from: $0, id: product.id) }
        for productName in productNames {
            try await productName.save(on: database)
        }
        
        if let productDtoBrands = productDto.brands {
            let productBrands: [ProductBrand] = productDtoBrands.compactMap { .init(from: $0, id: product.id) }
            for productBrand in productBrands {
                try await productBrand.save(on: database)
            }
        }
        
        if let productDtoServings = productDto.servings {
            let productServings: [ProductServing] = productDtoServings.map { .init(from: $0, id: product.id) }
            for productServing in productServings {
                try await productServing.save(on: database)
            }
        }
    }
    
    /// Performs a Product search for a given `searchText` and `page`.
    ///
    /// All the needed relations of the `Product` model are already lazy loaded.
    /// - Warning: As of Vapor Fluent 4.8.0 it's not possible to perform a `GROUP BY` which is needed for this query as we otherwise end up with duplicates or the limit breaks if we filter them out. Therefore, we rely for this on a raw SQL query for now.
    private func productSearch(_ searchText: String, page: Int) async throws -> [Product] {
        guard let database, let sql = database as? SQLDatabase else {
            throw Abort(.internalServerError, reason: "Database not supported.")
        }

        let searchTextPattern = "%" + searchText.lowercased() + "%"
        let limit = Constants.pageSize
        let offset = page * Constants.pageSize
        
        let rawQuery = SQLQueryString("""
            SELECT \(raw: Product.schema).*
            FROM \(raw: Product.schema)
            INNER JOIN \(raw: ProductName.schema) ON \(raw: Product.schema).id = \(raw: ProductName.schema).id
            LEFT JOIN \(raw: ProductBrand.schema) ON \(raw: Product.schema).id = \(raw: ProductBrand.schema).id
            WHERE \(raw: ProductName.schema).name_lowercase LIKE \(bind: searchTextPattern)
            OR \(raw: ProductBrand.schema).brand_lowercase LIKE \(bind: searchTextPattern)
            GROUP BY \(raw: Product.schema).id
            LIMIT \(bind: limit) OFFSET \(bind: offset)
            """)
        
        let products = try await sql.raw(rawQuery)
            .all(decoding: Product.self)
        for product in products {
            _ = try await product.$productNames.get(on: database)
            _ = try await product.$nutriments.get(on: database)
            _ = try await product.$productBrands.get(on: database)
            _ = try await product.$productServings.get(on: database)
        }
        return products
    }
}
