import Foundation

enum ProductMappingHelperError: Error {
    case invalidUUID
}

enum ProductMappingHelper {    
    static func convertToDto(_ info: ProductInfo) throws -> Components.Schemas.Product {
        let product = info.product
        return Components.Schemas.Product(id: product.id.uuidString,
                                          barcode: product.barcode,
                                          names: getLocalizedNames(for: info),
                                          brands: getLocalizedBrands(for: info),
                                          servings: getServings(from: info),
                                          totalQuantity: .init(product: product),
                                          nutriments: .init(from: info.productNutriments),
                                          verified: product.verified,
                                          source: product.source)
    }
    
    static func convertFromDto(_ dto: Components.Schemas.Product) throws -> Product {
        guard let id = UUID(uuidString: dto.id) else {
            throw ProductMappingHelperError.invalidUUID
        }
        return Product(id: id,
                       barcode: dto.barcode,
                       quantityUnit: dto.totalQuantity.unit.unit,
                       quantityValue: Int(dto.totalQuantity.value),
                       source: dto.source,
                       verified: true
        )
    }
    
    static func mapToPreviewDto(_ info: ProductInfo) -> Components.Schemas.ProductPreview {
        let product = info.product
        return Components.Schemas.ProductPreview(
            id: product.id.uuidString,
            names: getLocalizedNames(for: info),
            brands: getLocalizedBrands(for: info),
            servings: getServings(from: info),
            totalQuantity: .init(product: product),
            calories: info.productNutriments.energy100g,
            verified: product.verified
        )
    }
    
    private static func getLocalizedNames(for info: ProductInfo) -> [Components.Schemas.LocalizedValue] {
        return info.productNames.map { .init(value: $0.name, languageCode: $0.languageCode) }
    }
    
    private static func getLocalizedBrands(for info: ProductInfo) -> [Components.Schemas.LocalizedValue] {
        return info.productBrands.map { .init(value: $0.brand, languageCode: $0.languageCode) }
    }
    
    private static func getServings(from info: ProductInfo) -> [Components.Schemas.Serving] {
        return info.productServings.compactMap { .init(from: $0) }
    }
}

private extension QuantityUnit {
    var dto: Components.Schemas.Quantity.unitPayload {
        switch self {
        case .ml:
            return .ml
        case .l:
            return .l
        case .microgram:
            return .microgram
        case .mg:
            return .mg
        case .g:
            return .g
        case .kg:
            return .kg
        }
    }
}

private extension Components.Schemas.Quantity.unitPayload {
    var unit: QuantityUnit {
        switch self {
        case .ml:
            return .ml
        case .l:
            return .l
        case .microgram:
            return .microgram
        case .mg:
            return .mg
        case .g:
            return .g
        case .kg:
            return .kg
        }
    }
}

extension Components.Schemas.Quantity {
    init(product: Product) {
        self.init(unit: product.quantityUnit.dto, value: Int64(product.quantityValue))
    }
}

extension ProductNutriments {
    init(from nutriments: Components.Schemas.Nutriments, id: UUID) {
        self.init(
            id: id,
            energy100g: nutriments.energy,
            proteins100g: nutriments.proteins,
            fat100g: nutriments.fats,
            carbohydrates100g: nutriments.carbohydrates,
            betaCarotene100g: nutriments.vitamins?.betaCarotene,
            salt100g: nutriments.minerals?.salt,
            casein100g: nutriments.proteinsDetails?.casein,
            serumProteins100g: nutriments.proteinsDetails?.serumProteins,
            nucleotides100g: nutriments.misc?.nucleotides,
            sugars100g: nutriments.carbohydratesDetails?.sugars,
            sucrose100g: nutriments.carbohydratesDetails?.sucrose,
            glucose100g: nutriments.carbohydratesDetails?.glucose,
            fructose100g: nutriments.carbohydratesDetails?.fructose,
            lactose100g: nutriments.carbohydratesDetails?.lactose,
            maltose100g: nutriments.carbohydratesDetails?.maltose,
            maltodextrins100g: nutriments.carbohydratesDetails?.maltodextrins,
            starch100g: nutriments.carbohydratesDetails?.starch,
            polyols100g: nutriments.carbohydratesDetails?.polyols,
            saturatedFat100g: nutriments.fatDetails?.saturatedFat,
            butyricAcid100g: nutriments.fatDetails?.butyricAcid,
            caproicAcid100g: nutriments.fatDetails?.caproicAcid,
            caprylicAcid100g: nutriments.fatDetails?.caprylicAcid,
            capricAcid100g: nutriments.fatDetails?.capricAcid,
            lauricAcid100g: nutriments.fatDetails?.lauricAcid,
            myristicAcid100g: nutriments.fatDetails?.myristicAcid,
            palmiticAcid100g: nutriments.fatDetails?.palmiticAcid,
            stearicAcid100g: nutriments.fatDetails?.stearicAcid,
            arachidicAcid100g: nutriments.fatDetails?.arachidicAcid,
            behenicAcid100g: nutriments.fatDetails?.behenicAcid,
            lignocericAcid100g: nutriments.fatDetails?.lignocericAcid,
            ceroticAcid100g: nutriments.fatDetails?.ceroticAcid,
            montanicAcid100g: nutriments.fatDetails?.montanicAcid,
            melissicAcid100g: nutriments.fatDetails?.melissicAcid,
            monounsaturatedFat100g: nutriments.fatDetails?.monounsaturatedFat,
            polyunsaturatedFat100g: nutriments.fatDetails?.polyunsaturatedFat,
            omega3Fat100g: nutriments.fatDetails?.omega3Fat,
            alphaLinolenicAcid100g: nutriments.fatDetails?.alphaLinolenicAcid,
            eicosapentaenoicAcid100g: nutriments.fatDetails?.eicosapentaenoicAcid,
            docosahexaenoicAcid100g: nutriments.fatDetails?.docosahexaenoicAcid,
            omega6Fat100g: nutriments.fatDetails?.omega6Fat,
            linoleicAcid100g: nutriments.fatDetails?.linoleicAcid,
            arachidonicAcid100g: nutriments.fatDetails?.arachidonicAcid,
            gammaLinolenicAcid100g: nutriments.fatDetails?.gammaLinolenicAcid,
            dihomoGammaLinolenicAcid100g: nutriments.fatDetails?.dihomoGammaLinolenicAcid,
            omega9Fat100g: nutriments.fatDetails?.omega9Fat,
            oleicAcid100g: nutriments.fatDetails?.oleicAcid,
            elaidicAcid100g: nutriments.fatDetails?.elaidicAcid,
            gondoicAcid100g: nutriments.fatDetails?.gondoicAcid,
            meadAcid100g: nutriments.fatDetails?.meadAcid,
            erucicAcid100g: nutriments.fatDetails?.erucicAcid,
            nervonicAcid100g: nutriments.fatDetails?.nervonicAcid,
            transFat100g: nutriments.fatDetails?.transFat,
            cholesterol100g: nutriments.fatDetails?.cholesterol,
            fiber100g: nutriments.misc?.fiber,
            sodium100g: nutriments.minerals?.sodium,
            alcohol100g: nutriments.misc?.alcohol,
            vitaminA100g: nutriments.vitamins?.vitaminA,
            vitaminD100g: nutriments.vitamins?.vitaminD,
            vitaminE100g: nutriments.vitamins?.vitaminE,
            vitaminK100g: nutriments.vitamins?.vitaminK,
            vitaminC100g: nutriments.vitamins?.vitaminC,
            vitaminB1100g: nutriments.vitamins?.vitaminB1,
            vitaminB2100g: nutriments.vitamins?.vitaminB2,
            vitaminPp100g: nutriments.vitamins?.vitaminPP,
            vitaminB6100g: nutriments.vitamins?.vitaminB6,
            vitaminB9100g: nutriments.vitamins?.vitaminB9,
            vitaminB12100g: nutriments.vitamins?.vitaminB12,
            biotin100g: nutriments.vitamins?.biotin,
            pantothenicAcid100g: nutriments.vitamins?.pantothenicAcid,
            silica100g: nutriments.minerals?.silica,
            bicarbonate100g: nutriments.minerals?.bicarbonate,
            potassium100g: nutriments.minerals?.potassium,
            chloride100g: nutriments.minerals?.chloride,
            calcium100g: nutriments.minerals?.calcium,
            phosphorus100g: nutriments.minerals?.phosphorus,
            iron100g: nutriments.minerals?.iron,
            magnesium100g: nutriments.minerals?.magnesium,
            zinc100g: nutriments.minerals?.zinc,
            copper100g: nutriments.minerals?.copper,
            manganese100g: nutriments.minerals?.manganese,
            fluoride100g: nutriments.minerals?.fluoride,
            selenium100g: nutriments.minerals?.selenium,
            chromium100g: nutriments.minerals?.chromium,
            molybdenum100g: nutriments.minerals?.molybdenum,
            iodine100g: nutriments.minerals?.iodine,
            caffeine100g: nutriments.misc?.caffeine,
            taurine100g: nutriments.misc?.taurine
        )
    }
}

extension Components.Schemas.Nutriments {
    init(from productNutriments: ProductNutriments) {
        self.init(
            energy: productNutriments.energy100g,
            fats: productNutriments.fat100g,
            proteins: productNutriments.proteins100g,
            carbohydrates: productNutriments.carbohydrates100g,
            fatDetails: Components.Schemas.Fats(
                saturatedFat: productNutriments.saturatedFat100g,
                butyricAcid: productNutriments.butyricAcid100g,
                caproicAcid: productNutriments.caproicAcid100g,
                caprylicAcid: productNutriments.caprylicAcid100g,
                capricAcid: productNutriments.capricAcid100g,
                lauricAcid: productNutriments.lauricAcid100g,
                myristicAcid: productNutriments.myristicAcid100g,
                palmiticAcid: productNutriments.palmiticAcid100g,
                stearicAcid: productNutriments.stearicAcid100g,
                arachidicAcid: productNutriments.arachidicAcid100g,
                behenicAcid: productNutriments.behenicAcid100g,
                lignocericAcid: productNutriments.lignocericAcid100g,
                ceroticAcid: productNutriments.ceroticAcid100g,
                montanicAcid: productNutriments.montanicAcid100g,
                melissicAcid: productNutriments.melissicAcid100g,
                monounsaturatedFat: productNutriments.monounsaturatedFat100g,
                polyunsaturatedFat: productNutriments.polyunsaturatedFat100g,
                alphaLinolenicAcid: productNutriments.alphaLinolenicAcid100g,
                eicosapentaenoicAcid: productNutriments.eicosapentaenoicAcid100g,
                docosahexaenoicAcid: productNutriments.docosahexaenoicAcid100g,
                omega3Fat: productNutriments.omega3Fat100g,
                omega6Fat: productNutriments.omega6Fat100g,
                omega9Fat: productNutriments.omega9Fat100g,
                arachidonicAcid: productNutriments.arachidonicAcid100g,
                gammaLinolenicAcid: productNutriments.gammaLinolenicAcid100g,
                dihomoGammaLinolenicAcid: productNutriments.dihomoGammaLinolenicAcid100g,
                linoleicAcid: productNutriments.linoleicAcid100g,
                oleicAcid: productNutriments.oleicAcid100g,
                transFat: productNutriments.transFat100g,
                cholesterol: productNutriments.cholesterol100g,
                elaidicAcid: productNutriments.elaidicAcid100g,
                gondoicAcid: productNutriments.gondoicAcid100g,
                meadAcid: productNutriments.meadAcid100g,
                erucicAcid: productNutriments.erucicAcid100g,
                nervonicAcid: productNutriments.nervonicAcid100g
            ),
            proteinsDetails: Components.Schemas.Proteins(
                casein: productNutriments.casein100g,
                serumProteins: productNutriments.serumProteins100g
            ),
            carbohydratesDetails: Components.Schemas.Carbohydrates(
                sugars: productNutriments.sugars100g,
                sucrose: productNutriments.sucrose100g,
                glucose: productNutriments.glucose100g,
                fructose: productNutriments.fructose100g,
                lactose: productNutriments.lactose100g,
                maltose: productNutriments.maltose100g,
                maltodextrins: productNutriments.maltodextrins100g,
                starch: productNutriments.starch100g,
                polyols: productNutriments.polyols100g
            ),
            vitamins: Components.Schemas.Vitamins(
                vitaminA: productNutriments.vitaminA100g,
                vitaminB1: productNutriments.vitaminB1100g,
                vitaminB2: productNutriments.vitaminB2100g,
                vitaminPP: productNutriments.vitaminPp100g,
                vitaminB6: productNutriments.vitaminB6100g,
                vitaminB9: productNutriments.vitaminB9100g,
                vitaminB12: productNutriments.vitaminB12100g,
                vitaminC: productNutriments.vitaminC100g,
                vitaminD: productNutriments.vitaminD100g,
                vitaminE: productNutriments.vitaminE100g,
                vitaminK: productNutriments.vitaminK100g,
                betaCarotene: productNutriments.betaCarotene100g,
                pantothenicAcid: productNutriments.pantothenicAcid100g,
                biotin: productNutriments.biotin100g
            ),
            minerals: Components.Schemas.Minerals(
                calcium: productNutriments.calcium100g,
                phosphorus: productNutriments.phosphorus100g,
                iron: productNutriments.iron100g,
                magnesium: productNutriments.magnesium100g,
                zinc: productNutriments.zinc100g,
                copper: productNutriments.copper100g,
                manganese: productNutriments.manganese100g,
                fluoride: productNutriments.fluoride100g,
                selenium: productNutriments.selenium100g,
                iodine: productNutriments.iodine100g,
                chromium: productNutriments.chromium100g,
                molybdenum: productNutriments.molybdenum100g,
                salt: productNutriments.salt100g,
                chloride: productNutriments.chloride100g,
                bicarbonate: productNutriments.bicarbonate100g,
                potassium: productNutriments.potassium100g,
                sodium: productNutriments.sodium100g,
                silica: productNutriments.silica100g
            ),
            misc: Components.Schemas.MiscaleanousNutriments(
                caffeine: productNutriments.caffeine100g,
                taurine: productNutriments.taurine100g,
                nucleotides: productNutriments.nucleotides100g,
                fiber: productNutriments.fiber100g,
                alcohol: productNutriments.alcohol100g
            )
        )
    }
}

extension ProductName {
    init?(from dto: Components.Schemas.LocalizedValue, id: UUID) {
        guard let languageCode = dto.languageCode, let value = dto.value else {
            return nil
        }
        self.init(
            id: id,
            languageCode: languageCode,
            name: value
        )
    }
}

extension ProductBrand {
    init?(from dto: Components.Schemas.LocalizedValue, id: UUID) {
        guard let languageCode = dto.languageCode, let value = dto.value else {
            return nil
        }
        self.init(id: id,
                  languageCode: languageCode,
                  brand: value)
    }
}

extension Components.Schemas.Serving {
    init?(from serving: ProductServing) {
        guard let name = Components.Schemas.Serving.namePayload(rawValue: serving.name) else { return nil }
        self.init(name: name,
                  underlyingQuantity: .init(unit: serving.quantityUnit.dto,
                                            value: Int64(serving.quantityValue)))
    }
}

extension ProductServing {
    init(from dto: Components.Schemas.Serving, id: UUID) {
        self.init(id: id, name: dto.name.rawValue, quantityUnit: dto.underlyingQuantity.unit.unit, quantityValue: Int(dto.underlyingQuantity.value))
    }
}
