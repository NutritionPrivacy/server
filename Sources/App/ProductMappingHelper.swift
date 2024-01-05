import Foundation

enum ProductMappingHelperError: Error {
    case invalidUUID
}

enum ProductMappingHelper {
    static let source = "NutritionPrivacy"
    
    static func convertToDto(_ product: Product) -> Components.Schemas.Product {
        Components.Schemas.Product(id: product.id?.uuidString ?? "N/A",
                                   barcode: product.barcode,
                                   names: getLocalizedNames(for: product),
                                   brands: getLocalizedBrands(for: product),
                                   servings: getServings(from: product),
                                   totalQuantity: getQuantity(from: product),
                                   nutriments: .init(from: product.nutriments),
                                   verified: product.verified,
                                   source: source)
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
    
    private static func getLocalizedNames(for product: Product) -> [Components.Schemas.LocalizedValue] {
        assert(product.$productNames.value != nil)
        
        return product.productNames.map { .init(value: $0.name, languageCode: $0.id?.languageCode) }
    }
    
    private static func getLocalizedBrands(for product: Product) -> [Components.Schemas.LocalizedValue] {
        assert(product.$productBrands.value != nil)
        
        return product.productBrands.map { .init(value: $0.brand, languageCode: $0.id?.languageCode) }
    }
    
    private static func getQuantity(from product: Product) -> Components.Schemas.Quantity {
        Components.Schemas.Quantity(unit: product.quantityUnit.dto,
                                    value: Int64(product.quantityValue))
    }
    
    private static func getServings(from product: Product) -> [Components.Schemas.Serving] {
        assert(product.$productServings.value != nil)
        return product.productServings.compactMap { .init(from: $0) }
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

extension ProductNutriments {
    convenience init(from nutriments: Components.Schemas.Nutriments) {
        self.init(
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


extension ProductNutriments {
    
    /*convenience init(from nutriments: Components.Schemas.Nutriments) {
        self.init()
        // Required fields
        self.energy100g = nutriments.energy
        self.proteins100g = nutriments.proteins
        self.fat100g = nutriments.fats
        self.carbohydrates100g = nutriments.carbohydrates

        // Optional fields
        self.betaCarotene100g = nutriments.vitamins?.betaCarotene
        self.salt100g = nutriments.minerals?.salt
        self.casein100g = nutriments.proteinsDetails?.casein
        self.serumProteins100g = nutriments.proteinsDetails?.serumProteins
        self.nucleotides100g = nutriments.misc?.nucleotides
        self.sugars100g = nutriments.carbohydratesDetails?.sugars
        self.sucrose100g = nutriments.carbohydratesDetails?.sucrose
        self.glucose100g = nutriments.carbohydratesDetails?.glucose
        self.fructose100g = nutriments.carbohydratesDetails?.fructose
        self.lactose100g = nutriments.carbohydratesDetails?.lactose
        self.maltose100g = nutriments.carbohydratesDetails?.maltose
        self.maltodextrins100g = nutriments.carbohydratesDetails?.maltodextrins
        self.starch100g = nutriments.carbohydratesDetails?.starch
        self.polyols100g = nutriments.carbohydratesDetails?.polyols
        self.saturatedFat100g = nutriments.fatDetails?.saturatedFat
        self.butyricAcid100g = nutriments.fatDetails?.butyricAcid
        self.caproicAcid100g = nutriments.fatDetails?.caproicAcid
        self.caprylicAcid100g = nutriments.fatDetails?.caprylicAcid
        self.capricAcid100g = nutriments.fatDetails?.capricAcid
        self.lauricAcid100g = nutriments.fatDetails?.lauricAcid
        self.myristicAcid100g = nutriments.fatDetails?.myristicAcid
        self.palmiticAcid100g = nutriments.fatDetails?.palmiticAcid
        self.stearicAcid100g = nutriments.fatDetails?.stearicAcid
        self.arachidicAcid100g = nutriments.fatDetails?.arachidicAcid
        self.behenicAcid100g = nutriments.fatDetails?.behenicAcid
        self.lignocericAcid100g = nutriments.fatDetails?.lignocericAcid
        self.ceroticAcid100g = nutriments.fatDetails?.ceroticAcid
        self.montanicAcid100g = nutriments.fatDetails?.montanicAcid
        self.melissicAcid100g = nutriments.fatDetails?.melissicAcid
        self.monounsaturatedFat100g = nutriments.fatDetails?.monounsaturatedFat
        self.polyunsaturatedFat100g = nutriments.fatDetails?.polyunsaturatedFat
        self.omega3Fat100g = nutriments.fatDetails?.omega3Fat
        self.alphaLinolenicAcid100g = nutriments.fatDetails?.alphaLinolenicAcid
        self.eicosapentaenoicAcid100g = nutriments.fatDetails?.eicosapentaenoicAcid
        self.docosahexaenoicAcid100g = nutriments.fatDetails?.docosahexaenoicAcid
        self.omega6Fat100g = nutriments.fatDetails?.omega6Fat
        self.linoleicAcid100g = nutriments.fatDetails?.linoleicAcid
        self.arachidonicAcid100g = nutriments.fatDetails?.arachidonicAcid
        self.gammaLinolenicAcid100g = nutriments.fatDetails?.gammaLinolenicAcid
        self.dihomoGammaLinolenicAcid100g = nutriments.fatDetails?.dihomoGammaLinolenicAcid
        self.omega9Fat100g = nutriments.fatDetails?.omega9Fat
        self.oleicAcid100g = nutriments.fatDetails?.oleicAcid
        self.elaidicAcid100g = nutriments.fatDetails?.elaidicAcid
        self.gondoicAcid100g = nutriments.fatDetails?.gondoicAcid
        self.meadAcid100g = nutriments.fatDetails?.meadAcid
        self.erucicAcid100g = nutriments.fatDetails?.erucicAcid
        self.nervonicAcid100g = nutriments.fatDetails?.nervonicAcid
        self.transFat100g = nutriments.fatDetails?.transFat
        self.cholesterol100g = nutriments.fatDetails?.cholesterol
        self.fiber100g = nutriments.misc?.fiber
        self.sodium100g = nutriments.minerals?.sodium
        self.alcohol100g = nutriments.misc?.alcohol
        self.vitaminA100g = nutriments.vitamins?.vitaminA
        self.vitaminD100g = nutriments.vitamins?.vitaminD
        self.vitaminE100g = nutriments.vitamins?.vitaminE
        self.vitaminK100g = nutriments.vitamins?.vitaminK
        self.vitaminC100g = nutriments.vitamins?.vitaminC
        self.vitaminB1100g = nutriments.vitamins?.vitaminB1
        self.vitaminB2100g = nutriments.vitamins?.vitaminB2
        self.vitaminPp100g = nutriments.vitamins?.vitaminPP
        self.vitaminB6100g = nutriments.vitamins?.vitaminB6
        self.vitaminB9100g = nutriments.vitamins?.vitaminB9
        self.vitaminB12100g = nutriments.vitamins?.vitaminB12
        self.biotin100g = nutriments.vitamins?.biotin
        self.pantothenicAcid100g = nutriments.vitamins?.pantothenicAcid
        self.silica100g = nutriments.minerals?.silica
        self.bicarbonate100g = nutriments.minerals?.bicarbonate
        self.potassium100g = nutriments.minerals?.potassium
        self.chloride100g = nutriments.minerals?.chloride
        self.calcium100g = nutriments.minerals?.calcium
        self.phosphorus100g = nutriments.minerals?.phosphorus
        self.iron100g = nutriments.minerals?.iron
        self.magnesium100g = nutriments.minerals?.magnesium
        self.zinc100g = nutriments.minerals?.zinc
        self.copper100g = nutriments.minerals?.copper
        self.manganese100g = nutriments.minerals?.manganese
        self.fluoride100g = nutriments.minerals?.fluoride
        self.selenium100g = nutriments.minerals?.selenium
        self.chromium100g = nutriments.minerals?.chromium
        self.molybdenum100g = nutriments.minerals?.molybdenum
        self.iodine100g = nutriments.minerals?.iodine
        self.caffeine100g = nutriments.misc?.caffeine
        self.taurine100g = nutriments.misc?.taurine
        }*/
}

extension Components.Schemas.Nutriments {
    init(from productNutriments: ProductNutriments) {
        self.init(
            energy: productNutriments.energy100g,
            fats: productNutriments.fat100g,
            proteins: Int(productNutriments.proteins100g),
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
    convenience init?(from dto: Components.Schemas.LocalizedValue, id: UUID?) {
        guard let languageCode = dto.languageCode, let value = dto.value else {
            return nil
        }
        self.init(id: id,
                  languageCode: languageCode,
                  name: value)
    }
}

extension ProductBrand {
    convenience init?(from dto: Components.Schemas.LocalizedValue, id: UUID?) {
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
        guard let id = serving.id else { return nil }
        guard let name = Components.Schemas.Serving.namePayload(rawValue: id.name) else { return nil }
        self.init(name: name,
                  underlyingQuantity: .init(unit: serving.quantityUnit.dto,
                                            value: Int64(serving.quantityValue)))
    }
}

extension ProductServing {
    convenience init(from dto: Components.Schemas.Serving, id: UUID?) {
        self.init(id: id, name: dto.name.rawValue, quantityUnit: dto.underlyingQuantity.unit.unit, quantityValue: Int(dto.underlyingQuantity.value))
    }
}
