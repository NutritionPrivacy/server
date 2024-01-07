import Foundation
import SQLKit

struct ProductInfo: Codable {
    let product: Product
    let productNutriments: ProductNutriments
    let productNames: [ProductName]
    let productBrands: [ProductBrand]
    let productServings: [ProductServing]
}
