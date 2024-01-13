@testable import App
import SQLKit
import PostgresKit
import SQLiteKit
import XCTVapor
@testable import FluentPostgresDriver

final class AppTests: XCTestCase {
    private let fullProductJSONId = UUID(uuidString: "88F14A16-364A-4D82-A327-028B18769194")!
    private var app: Application!
    
    override func setUp() async throws {
        app = Application(.testing)
        try await configure(app)
        try await resetDatabase()
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    /// Resets the database.
    /// This is needed to run the unit tests in isolation with a Postgres Server.
    private func resetDatabase() async throws {
        try await app.autoRevert()
        try await app.autoMigrate()
    }
    
    // MARK: addProduct
    
    func test_addProduct_savesProductToDatabase() async throws {
        // GIVEN
        // no products are in the database yet
        let initialTotalProducts = try await Product.queryCount(on: try getSqlDatabase())
        XCTAssertEqual(initialTotalProducts, 0)
        
        // WHEN
        // sending a POST request to the product endpoint with a full product JSON
        try await app.test(.POST, "/product", beforeRequest: { req in
            req.headers.contentType = .json
            req.body = .init(string: TestData.fullProductJSON)
        }, afterResponse: { res in
            // THEN
            // the response status code is 200
            XCTAssertEqual(res.status, .ok)
            
            // 1 product is now in the database
            let totalProducts = try await Product.queryCount(on: try getSqlDatabase())
            XCTAssertEqual(totalProducts, 1)
            
            // the saved product matches the id of the full product JSON.
            let fetchedProduct =  try await Product.getProduct(id: fullProductJSONId, database: try getSqlDatabase())
            XCTAssertNotNil(fetchedProduct, "No product for the test id has been saved to the database")
        })
        
        // WHEN
        // sending a GET request to the product endpoint with the id of the full product JSON
        try app.test(.GET, "/product/\(fullProductJSONId.uuidString)", afterResponse: { response in
            // THEN
            // the response status code is 200
            XCTAssertEqual(response.status, .ok)
            let testData = try JSONSerialization.jsonObject(with: TestData.fullProductJSON.data(using: .utf8)!) as! [String: Any]
            let responseData = try XCTUnwrap(response.body.string.data(using: .utf8))
            let jsonResponse = try JSONSerialization.jsonObject(with: responseData)
            let jsonDict = try XCTUnwrap(jsonResponse as? [String: Any])
            // and the retrieved JSON matches exactly the JSON of the full product test data.
            XCTAssertEqualJSONDictionaries(testData, jsonDict)
        })
    }
    
    func test_addProduct_calledTwiceForSameID_failsWith409() async throws {
        // GIVEN
        // no products are in the database yet
        let initialTotalProducts = try await Product.queryCount(on: try getSqlDatabase())
        XCTAssertEqual(initialTotalProducts, 0)
        
        // WHEN
        // sending a POST request to the product endpoint with a full product JSON
        try await app.test(.POST, "/product", beforeRequest: { req in
            req.headers.contentType = .json
            req.body = .init(string: TestData.fullProductJSON)
        }, afterResponse: { res in
            // THEN
            // the response status code is 200
            XCTAssertEqual(res.status, .ok)
            
            // 1 product is now in the database
            let totalProducts = try await Product.queryCount(on: try getSqlDatabase())
            XCTAssertEqual(totalProducts, 1)
        })
        
        // WHEN
        // sending a 2nd POST request to the product endpoint with the same full product JSON
        try await app.test(.POST, "/product", beforeRequest: { req in
            req.headers.contentType = .json
            req.body = .init(string: TestData.fullProductJSON)
        }, afterResponse: { res in
            // THEN
            // the response status code is 409
            XCTAssertEqual(res.status, .conflict)
            
            // and still only 1 product is in the database
            let totalProducts = try await Product.queryCount(on: try getSqlDatabase())
            XCTAssertEqual(totalProducts, 1)
        })
    }
    
    // MARK: getProductByID
    
    func test_getProductById() async throws {
        // GIVEN
        // a product exists in the database
        let product = try await createProductEntry()
        let productID = try XCTUnwrap(product.id)
        
        try await TestData.createDummyProductName(id: productID, name: "TestName", languageCode: "en")
            .save(on: try getSqlDatabase())
        
        // WHEN
        // sending a GET request to the product endpoint with the id of the previously saved product
        try app.test(.GET, "/product/\(productID)", afterResponse: { response in
            // THEN
            // the response status code is 200
            XCTAssertEqual(response.status, .ok)
            
        })
    }
    
    // MARK: searchByText
    
    func test_searchByText_prefixName() async throws {
        let id = UUID()
        let database = try getSqlDatabase()
        try await TestData.createDummyProduct(id: id)
            .save(on: database)
        
        try await TestData.createDummyProductNutriments(id: id,
                                                        energy100g: 100,
                                                        proteins100g: 20,
                                                        fat100g: 10,
                                                        carbohydrates100g: 240)
            .save(on: database)
        
        try await TestData.createDummyProductName(id: id, name: "TestName1", languageCode: "en-US")
            .save(on: database)
        
        try await TestData.createDummyProductName(id: id, name: "TestName2", languageCode: "de-DE")
            .save(on: database)
        
        // WHEN
        // sending a GET request with the prefix "Te"
        
        try app.test(.GET, "product?text=Te&page=0", afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let productResponseDto = try JSONDecoder().decode(Components.Schemas.ProductsSearchResponse.self, from: response.body)
            let products = try XCTUnwrap(productResponseDto.array)
            XCTAssertEqual(products.count, 1)
        })
    }
    
    func test_searchByText_infixName() async throws {
        let id = UUID()
        let database = try getSqlDatabase()
        try await TestData.createDummyProduct(id: id)
            .save(on: database)
        
        try await TestData.createDummyProductNutriments(id: id,
                                                        energy100g: 100,
                                                        proteins100g: 20,
                                                        fat100g: 10,
                                                        carbohydrates100g: 240)
            .save(on: database)
        
        try await TestData.createDummyProductName(id: id, name: "TestName1", languageCode: "en-US")
            .save(on: database)
        
        try await TestData.createDummyProductName(id: id, name: "TestName2", languageCode: "de-DE")
            .save(on: database)
        
        // WHEN
        // sending a GET request with the infix "st"
        
        try app.test(.GET, "product?text=st&page=0", afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let productResponseDto = try JSONDecoder().decode(Components.Schemas.ProductsSearchResponse.self, from: response.body)
            let products = try XCTUnwrap(productResponseDto.array)
            XCTAssertEqual(products.count, 1)
        })
    }
    
    func test_searchByText_limit() async throws {
        // GIVEN
        // 30 Products with 30 localized names each are stored in the database
        let database = try getSqlDatabase()
        for _ in 0..<30 {
            let product = try await createProductEntry()
            let productID = try XCTUnwrap(product.id)
            for j in 0..<30 {
                try await TestData.createDummyProductName(id: productID, name: "TestName\(j)", languageCode: "\(j)")
                    .save(on: database)
            }
        }
        
        let savedProducts = try await Product.queryCount(on: database)
        XCTAssertEqual(savedProducts, 30)
        
        // WHEN
        // sending a GET request with the prefix "Te"
        try app.test(.GET, "product?text=Te&page=0", afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let productResponseDto = try JSONDecoder().decode(Components.Schemas.ProductsSearchResponse.self, from: response.body)
            let products = try XCTUnwrap(productResponseDto.array)
            // THEN
            // the returned products are the maximum page size
            XCTAssertEqual(products.count, 20)
        })
        
        // WHEN
        // sending a 2nd GET request with the prefix "Te" and page = 1
        try app.test(.GET, "product?text=Te&page=1", afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let productResponseDto = try JSONDecoder().decode(Components.Schemas.ProductsSearchResponse.self, from: response.body)
            let products = try XCTUnwrap(productResponseDto.array)
            // THEN
            // the returned products are the remaining 10 (Total: 30 -> 20 (Page = 0) & 10 (Page = 1)
            XCTAssertEqual(products.count, 10)
        })
    }
    
    // MARK: exportPreviews
    
    func test_exportPreviews() async throws {
        typealias ProductPreview = Components.Schemas.ProductPreview
        // GIVEN
        // 30 Products with 30 localized names each are stored in the database
        let database = try getSqlDatabase()
        var productPreviews = [ProductPreview]()
        for i in 0..<30 {
            let product = try await createProductEntry(energy100g: i)
            let productID = try XCTUnwrap(product.id)
            var names = [ProductName]()
            var brands = [ProductBrand]()
            for j in 0..<30 {
                let name =  TestData.createDummyProductName(id: productID, name: "TestName\(j)", languageCode: "\(j)")
                names.append(name)
                try await name.save(on: database)
                
                let brand = TestData.createDummyProductBrand(id: productID, brand: "TestBrand\(j)", languageCode: "\(j)")
                brands.append(brand)
                try await brand.save(on: database)
            }
            let preview = ProductPreview(
                id: productID.uuidString,
                names: names.map { .init(value: $0.name, languageCode: $0.languageCode) },
                brands:  brands.map { .init(value: $0.brand, languageCode: $0.languageCode) },
                servings: [],
                totalQuantity: Components.Schemas.Quantity(product: product),
                calories: i,
                verified: product.verified
            )
            productPreviews.append(preview)
        }
        
        let expectedJson = try createSortedJsonDictionaries(from: productPreviews)
        
        let savedProducts = try await Product.queryCount(on: database)
        XCTAssertEqual(savedProducts, 30)
        
        // WHEN
        // sending a GET request to the export/previews route
        try app.test(.GET, "export/previews", afterResponse: { response in
            // THEN
            // the returned product previews
            let productPreviewsDto = try JSONDecoder().decode([ProductPreview].self, from: response.body)
            XCTAssertEqual(productPreviewsDto.count, 30)
            let actualJson = try createSortedJsonDictionaries(from: productPreviewsDto)
            
            // and the retrieved JSON matches exactly the JSON of the full product test data.
            XCTAssertEqualJSONDictionaries(actualJson, expectedJson)
        })
    }
    
    func test_exportPreviews_production_routeIsForbidden() async throws {
        // GIVEN
        // a product exists in the database
        let database = try getSqlDatabase()
        _ = try await createProductEntry()
        let savedProducts = try await Product.queryCount(on: database)
        XCTAssertEqual(savedProducts, 1)
        
        // and the app env is production
        app.environment = .production
        
        // WHEN
        // sending a GET request to the export/previews route
        try app.test(.GET, "export/previews", afterResponse: { response in
            // THEN
            // the request is forbidden while the app is in production mode
            XCTAssertEqual(response.status, .forbidden)
        })
    }
    
    private func createProductEntry(energy100g: Int = 100) async throws -> Product {
        let id = UUID()
        let database = try getSqlDatabase()
        let product = TestData.createDummyProduct(id: id)
        try await product.save(on: database)
        
        let nutriments = TestData.createDummyProductNutriments(id: id,
                                                        energy100g: energy100g,
                                                        proteins100g: 20,
                                                        fat100g: 10,
                                                        carbohydrates100g: 240)
        try await nutriments.save(on: database)
        return product
    }
    
    private func getSqlDatabase() throws -> SQLDatabase {
        return try XCTUnwrap(app.db as? SQLDatabase)
    }
    
    private func createSortedJsonDictionaries(from previews: [Components.Schemas.ProductPreview]) throws -> [[String: Any]] {
        let sortedPreviews = previews.sorted(by: { $0.id < $1.id })
        let jsonData = try JSONEncoder().encode(sortedPreviews)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData)
        return try XCTUnwrap(jsonObject as? [[String: Any]])
    }
}

private func XCTAssertEqualJSONDictionaries(_ expression1: [[String: Any]], _ expression2: [[String: Any]], file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(expression1.count, expression2.count, file: file, line: line)
    for (index, element1) in expression1.enumerated() {
        guard let element2 = expression2[safe: index] else {
            XCTFail("Missing element, requested element at \(index) but could only find indices up to \(expression2.count - 1)", file: file, line: line)
            return
        }
        XCTAssertEqualJSONDictionaries(element1, element2, file: file, line: line)
    }
}

private func XCTAssertEqualJSONDictionaries(_ expression1: [String: Any], _ expression2: [String: Any], file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(expression1.count, expression2.count, file: file, line: line)
    
    for (key1,value1) in expression1 {
        let value2: Any
        do {
            value2 = try XCTUnwrap(expression2[key1], file: file, line: line)
        } catch {
            XCTFail("Missing key: \(key1) only found \(expression2.keys)", file: file, line: line)
            return
        }
        
        switch (value1, value2) {
        case (let value1 as Double, let value2 as Double):
            XCTAssertEqual(value1, value2, file: file, line: line)
        case (let value1 as Int, let value2 as Int):
            XCTAssertEqual(value1, value2, file: file, line: line)
        case (let value1 as String, let value2 as String):
            XCTAssertEqual(value1, value2, file: file, line: line)
        case (let value1 as Bool, let value2 as Bool):
            XCTAssertEqual(value1, value2, file: file, line: line)
        case (let value1 as [String: Any], let value2 as [String: Any]):
            XCTAssertEqualJSONDictionaries(value1, value2, file: file, line: line)
        case (let value1 as [[String: Any]], let value2 as [[String: Any]]):
            XCTAssertEqual(value1.count, value2.count, file: file, line: line)
            for (index, element1) in value1.enumerated() {
                guard let element2 = value2[safe: index] else {
                    XCTFail("Inner array does not have another dict", file: file, line: line)
                    return
                }
                XCTAssertEqualJSONDictionaries(element1, element2, file: file, line: line)
            }
            
        default:
            XCTFail("Unsupported value combination! Got \(type(of: value1)) and \(type(of: value2))", file: file, line: line)
        }
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Product {
    static func queryCount(on database: SQLDatabase) async throws -> Int {
        let columnName: String
        if database is PostgresDatabase {
            columnName = "count"
        } else if database is SQLiteDatabase {
            columnName = "COUNT(*)"
        } else {
            XCTFail("Unsupported Database type")
            throw TestError()
        }
        return try await database.raw("SELECT COUNT(*) FROM \(raw: Self.tableName)")
            .first()
            .unwrap()
            .decode(column: columnName, as: Int.self)
    }
    
    static func getProduct(id: UUID, database sql: SQLDatabase) async throws -> Product? {
        try await sql.raw("""
            SELECT *
            FROM \(raw: Self.tableName)
            WHERE "id" = \(bind: id)
            """)
        .first()?.decodeToSQLModel(Product.self, usePrefix: false)
    }
}

struct TestError: Error {}
