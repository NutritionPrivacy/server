@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    private let fullProductJSONId = UUID(uuidString: "88F14A16-364A-4D82-A327-028B18769194")!
    private var app: Application!
    
    override func setUp() async throws {
        app = Application(.testing)
        try await configure(app)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    // MARK: addProduct
    
    func test_addProduct_savesProductToDatabase() async throws {
        // GIVEN
        // no products are in the database yet
        let initialTotalProducts = try await Product.query(on: app.db).count()
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
            let totalProducts = try await Product.query(on: app.db).count()
            XCTAssertEqual(totalProducts, 1)
            
            // the saved product matches the id of the full product JSON.
            let fetchedProduct =  try await Product.query(on: app.db)
                .filter(.id, .equal, fullProductJSONId)
                .first()
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
        let initialTotalProducts = try await Product.query(on: app.db).count()
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
            let totalProducts = try await Product.query(on: app.db).count()
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
            let totalProducts = try await Product.query(on: app.db).count()
            XCTAssertEqual(totalProducts, 1)
        })
    }
        
    // MARK: searchByText
    
    func test_searchByText_prefixName() async throws {
        let id = UUID()
        try await TestData.createDummyProduct(id: id)
            .save(on: app.db)
        
        try await TestData.createDummyProductNutriments(id: id,
                                                        energy100g: 100,
                                                        proteins100g: 20,
                                                        fat100g: 10,
                                                        carbohydrates100g: 240)
            .save(on: app.db)
        
        try await TestData.createDummyProductName(id: id, name: "TestName1", languageCode: "en-US")
            .save(on: app.db)
        
        try await TestData.createDummyProductName(id: id, name: "TestName2", languageCode: "de-DE")
            .save(on: app.db)
        
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
        try await TestData.createDummyProduct(id: id)
            .save(on: app.db)
        
        try await TestData.createDummyProductNutriments(id: id,
                                                        energy100g: 100,
                                                        proteins100g: 20,
                                                        fat100g: 10,
                                                        carbohydrates100g: 240)
            .save(on: app.db)
        
        try await TestData.createDummyProductName(id: id, name: "TestName1", languageCode: "en-US")
            .save(on: app.db)
        
        try await TestData.createDummyProductName(id: id, name: "TestName2", languageCode: "de-DE")
            .save(on: app.db)
        
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
        for i in 0..<30 {
            let product = try await createProductEntry()
            let productID = try XCTUnwrap(product.id)
            for j in 0..<30 {
                try await TestData.createDummyProductName(id: productID, name: "TestName\(j)", languageCode: "\(j)")
                    .save(on: app.db)
            }
        }
        
        let savedProducts = try await Product.query(on: app.db).count()
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
    
    private func createProductEntry() async throws -> Product {
        let id = UUID()
        let product = TestData.createDummyProduct(id: id)
        try await product
            .save(on: app.db)
        
        try await TestData.createDummyProductNutriments(id: id,
                                                        energy100g: 100,
                                                        proteins100g: 20,
                                                        fat100g: 10,
                                                        carbohydrates100g: 240)
        .save(on: app.db)
        return product
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
