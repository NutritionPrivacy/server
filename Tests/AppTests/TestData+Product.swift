import Foundation
@testable import App

extension TestData {
//    static func createDummyProduct(id: UUID?, name: [String: String] = ["en": "TestName"], brand: [String: String]? = ["en": "TestBrand"]) -> Product {
//        Product(id: id, barcode: nil, quantityUnit: .g, quantityValue: 100, source: "TestSource", verified: true)
//    }
    static func createDummyProduct(id: UUID?, barcode: Int? = nil, quantityUnit: QuantityUnit = .g, quantityValue: Int = 100, source: String = "NutritionPrivacy", verified: Bool = true) -> Product {
        Product(id: id, barcode: barcode, quantityUnit: quantityUnit, quantityValue: quantityValue, source: source, verified: verified)
    }
    
    static func createDummyProductName(id: UUID, name: String = "TestName", languageCode: String = "en") -> ProductName {
        ProductName(id: id, languageCode: languageCode, name: name)
    }
    
    static func createDummyProductBrand(id: UUID, brand: String = "TestBrand", languageCode: String = "en") -> ProductBrand {
        ProductBrand(id: id, languageCode: languageCode, brand: brand)
    }
    
    static func createDummyProductNutriments(
            id: UUID,
            energy100g: Int,
            proteins100g: Int,
            fat100g: Double,
            carbohydrates100g: Double,
            betaCarotene100g: Double? = nil,
            salt100g: Double? = nil,
            casein100g: Double? = nil,
            serumProteins100g: Double? = nil,
            nucleotides100g: Double? = nil,
            sugars100g: Double? = nil,
            sucrose100g: Double? = nil,
            glucose100g: Double? = nil,
            fructose100g: Double? = nil,
            lactose100g: Double? = nil,
            maltose100g: Double? = nil,
            maltodextrins100g: Double? = nil,
            starch100g: Double? = nil,
            polyols100g: Double? = nil,
            saturatedFat100g: Double? = nil,
            butyricAcid100g: Double? = nil,
            caproicAcid100g: Double? = nil,
            caprylicAcid100g: Double? = nil,
            capricAcid100g: Double? = nil,
            lauricAcid100g: Double? = nil,
            myristicAcid100g: Double? = nil,
            palmiticAcid100g: Double? = nil,
            stearicAcid100g: Double? = nil,
            arachidicAcid100g: Double? = nil,
            behenicAcid100g: Double? = nil,
            lignocericAcid100g: Double? = nil,
            ceroticAcid100g: Double? = nil,
            montanicAcid100g: Double? = nil,
            melissicAcid100g: Double? = nil,
            monounsaturatedFat100g: Double? = nil,
            polyunsaturatedFat100g: Double? = nil,
            omega3Fat100g: Double? = nil,
            alphaLinolenicAcid100g: Double? = nil,
            eicosapentaenoicAcid100g: Double? = nil,
            docosahexaenoicAcid100g: Double? = nil,
            omega6Fat100g: Double? = nil,
            linoleicAcid100g: Double? = nil,
            arachidonicAcid100g: Double? = nil,
            gammaLinolenicAcid100g: Double? = nil,
            dihomoGammaLinolenicAcid100g: Double? = nil,
            omega9Fat100g: Double? = nil,
            oleicAcid100g: Double? = nil,
            elaidicAcid100g: Double? = nil,
            gondoicAcid100g: Double? = nil,
            meadAcid100g: Double? = nil,
            erucicAcid100g: Double? = nil,
            nervonicAcid100g: Double? = nil,
            transFat100g: Double? = nil,
            cholesterol100g: Double? = nil,
            fiber100g: Double? = nil,
            sodium100g: Double? = nil,
            alcohol100g: Double? = nil,
            vitaminA100g: Double? = nil,
            vitaminD100g: Double? = nil,
            vitaminE100g: Double? = nil,
            vitaminK100g: Double? = nil,
            vitaminC100g: Double? = nil,
            vitaminB1100g: Double? = nil,
            vitaminB2100g: Double? = nil,
            vitaminPp100g: Double? = nil,
            vitaminB6100g: Double? = nil,
            vitaminB9100g: Double? = nil,
            vitaminB12100g: Double? = nil,
            biotin100g: Double? = nil,
            pantothenicAcid100g: Double? = nil,
            silica100g: Double? = nil,
            bicarbonate100g: Double? = nil,
            potassium100g: Double? = nil,
            chloride100g: Double? = nil,
            calcium100g: Double? = nil,
            phosphorus100g: Double? = nil,
            iron100g: Double? = nil,
            magnesium100g: Double? = nil,
            zinc100g: Double? = nil,
            copper100g: Double? = nil,
            manganese100g: Double? = nil,
            fluoride100g: Double? = nil,
            selenium100g: Double? = nil,
            chromium100g: Double? = nil,
            molybdenum100g: Double? = nil,
            iodine100g: Double? = nil,
            caffeine100g: Double? = nil,
            taurine100g: Double? = nil
        ) -> ProductNutriments {
            let nutriments = ProductNutriments()
            nutriments.id = id
            nutriments.energy100g = energy100g
            nutriments.proteins100g = proteins100g
            nutriments.fat100g = fat100g
            nutriments.carbohydrates100g = carbohydrates100g
           
            // Optional fields
            nutriments.betaCarotene100g = betaCarotene100g
            nutriments.salt100g = salt100g
            nutriments.casein100g = casein100g
            nutriments.serumProteins100g = serumProteins100g
            nutriments.nucleotides100g = nucleotides100g
            nutriments.sugars100g = sugars100g
            nutriments.sucrose100g = sucrose100g
            nutriments.glucose100g = glucose100g
            nutriments.fructose100g = fructose100g
            nutriments.lactose100g = lactose100g
            nutriments.maltose100g = maltose100g
            nutriments.maltodextrins100g = maltodextrins100g
            nutriments.starch100g = starch100g
            nutriments.polyols100g = polyols100g
            nutriments.saturatedFat100g = saturatedFat100g
            nutriments.butyricAcid100g = butyricAcid100g
            nutriments.caproicAcid100g = caproicAcid100g
            nutriments.caprylicAcid100g = caprylicAcid100g
            nutriments.capricAcid100g = capricAcid100g
            nutriments.lauricAcid100g = lauricAcid100g
            nutriments.myristicAcid100g = myristicAcid100g
            nutriments.palmiticAcid100g = palmiticAcid100g
            nutriments.stearicAcid100g = stearicAcid100g
            nutriments.arachidicAcid100g = arachidicAcid100g
            nutriments.behenicAcid100g = behenicAcid100g
            nutriments.lignocericAcid100g = lignocericAcid100g
            nutriments.ceroticAcid100g = ceroticAcid100g
            nutriments.montanicAcid100g = montanicAcid100g
            nutriments.melissicAcid100g = melissicAcid100g
            nutriments.monounsaturatedFat100g = monounsaturatedFat100g
            nutriments.polyunsaturatedFat100g = polyunsaturatedFat100g
            nutriments.omega3Fat100g = omega3Fat100g
            nutriments.alphaLinolenicAcid100g = alphaLinolenicAcid100g
            nutriments.eicosapentaenoicAcid100g = eicosapentaenoicAcid100g
            nutriments.docosahexaenoicAcid100g = docosahexaenoicAcid100g
            nutriments.omega6Fat100g = omega6Fat100g
            nutriments.linoleicAcid100g = linoleicAcid100g
            nutriments.arachidonicAcid100g = arachidonicAcid100g
            nutriments.gammaLinolenicAcid100g = gammaLinolenicAcid100g
            nutriments.dihomoGammaLinolenicAcid100g = dihomoGammaLinolenicAcid100g
            nutriments.omega9Fat100g = omega9Fat100g
            nutriments.oleicAcid100g = oleicAcid100g
            nutriments.elaidicAcid100g = elaidicAcid100g
            nutriments.gondoicAcid100g = gondoicAcid100g
            nutriments.meadAcid100g = meadAcid100g
            nutriments.erucicAcid100g = erucicAcid100g
            nutriments.nervonicAcid100g = nervonicAcid100g
            nutriments.transFat100g = transFat100g
            nutriments.cholesterol100g = cholesterol100g
            nutriments.fiber100g = fiber100g
            nutriments.sodium100g = sodium100g
            nutriments.alcohol100g = alcohol100g
            nutriments.vitaminA100g = vitaminA100g
            nutriments.vitaminD100g = vitaminD100g
            nutriments.vitaminE100g = vitaminE100g
            nutriments.vitaminK100g = vitaminK100g
            nutriments.vitaminC100g = vitaminC100g
            nutriments.vitaminB1100g = vitaminB1100g
            nutriments.vitaminB2100g = vitaminB2100g
            nutriments.vitaminPp100g = vitaminPp100g
            nutriments.vitaminB6100g = vitaminB6100g
            nutriments.vitaminB9100g = vitaminB9100g
            nutriments.vitaminB12100g = vitaminB12100g
            nutriments.biotin100g = biotin100g
            nutriments.pantothenicAcid100g = pantothenicAcid100g
            nutriments.silica100g = silica100g
            nutriments.bicarbonate100g = bicarbonate100g
            nutriments.potassium100g = potassium100g
            nutriments.chloride100g = chloride100g
            nutriments.calcium100g = calcium100g
            nutriments.phosphorus100g = phosphorus100g
            nutriments.iron100g = iron100g
            nutriments.magnesium100g = magnesium100g
            nutriments.zinc100g = zinc100g
            nutriments.copper100g = copper100g
            nutriments.manganese100g = manganese100g
            nutriments.fluoride100g = fluoride100g
            nutriments.selenium100g = selenium100g
            nutriments.chromium100g = chromium100g
            nutriments.molybdenum100g = molybdenum100g
            nutriments.iodine100g = iodine100g
            nutriments.caffeine100g = caffeine100g
            nutriments.taurine100g = taurine100g

            return nutriments
        }

}
