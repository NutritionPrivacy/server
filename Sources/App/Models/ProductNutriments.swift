import Foundation
import SQLKit

struct ProductNutriments: Codable {
    
    let id: UUID

    let energy100g: Int

    let proteins100g: Double

    let fat100g: Double

    let carbohydrates100g: Double

    let betaCarotene100g: Double?

    let salt100g: Double?

    let casein100g: Double?

    let serumProteins100g: Double?

    let nucleotides100g: Double?

    let sugars100g: Double?

    let sucrose100g: Double?

    let glucose100g: Double?

    let fructose100g: Double?

    let lactose100g: Double?

    let maltose100g: Double?

    let maltodextrins100g: Double?

    let starch100g: Double?

    let polyols100g: Double?

    let saturatedFat100g: Double?

    let butyricAcid100g: Double?

    let caproicAcid100g: Double?

    let caprylicAcid100g: Double?

    let capricAcid100g: Double?

    let lauricAcid100g: Double?

    let myristicAcid100g: Double?

    let palmiticAcid100g: Double?

    let stearicAcid100g: Double?

    let arachidicAcid100g: Double?

    let behenicAcid100g: Double?

    let lignocericAcid100g: Double?

    let ceroticAcid100g: Double?

    let montanicAcid100g: Double?

    let melissicAcid100g: Double?

    let monounsaturatedFat100g: Double?

    let polyunsaturatedFat100g: Double?

    let omega3Fat100g: Double?

    let alphaLinolenicAcid100g: Double?

    let eicosapentaenoicAcid100g: Double?

    let docosahexaenoicAcid100g: Double?

    let omega6Fat100g: Double?

    let linoleicAcid100g: Double?

    let arachidonicAcid100g: Double?

    let gammaLinolenicAcid100g: Double?

    let dihomoGammaLinolenicAcid100g: Double?

    let omega9Fat100g: Double?

    let oleicAcid100g: Double?

    let elaidicAcid100g: Double?

    let gondoicAcid100g: Double?

    let meadAcid100g: Double?

    let erucicAcid100g: Double?

    let nervonicAcid100g: Double?

    let transFat100g: Double?

    let cholesterol100g: Double?

    let fiber100g: Double?

    let sodium100g: Double?

    let alcohol100g: Double?

    let vitaminA100g: Double?

    let vitaminD100g: Double?

    let vitaminE100g: Double?

    let vitaminK100g: Double?

    let vitaminC100g: Double?

    let vitaminB1100g: Double?

    let vitaminB2100g: Double?

    let vitaminPp100g: Double?

    let vitaminB6100g: Double?

    let vitaminB9100g: Double?

    let vitaminB12100g: Double?

    let biotin100g: Double?

    let pantothenicAcid100g: Double?

    let silica100g: Double?

    let bicarbonate100g: Double?

    let potassium100g: Double?

    let chloride100g: Double?

    let calcium100g: Double?

    let phosphorus100g: Double?

    let iron100g: Double?

    let magnesium100g: Double?

    let zinc100g: Double?

    let copper100g: Double?

    let manganese100g: Double?

    let fluoride100g: Double?

    let selenium100g: Double?

    let chromium100g: Double?

    let molybdenum100g: Double?

    let iodine100g: Double?

    let caffeine100g: Double?

    let taurine100g: Double?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case energy100g = "energy_100g"
        case proteins100g = "proteins_100g"
        case fat100g = "fat_100g"
        case carbohydrates100g = "carbohydrates_100g"
        case betaCarotene100g = "beta_carotene_100g"
        case salt100g = "salt_100g"
        case casein100g = "casein_100g"
        case serumProteins100g = "serum_proteins_100g"
        case nucleotides100g = "nucleotides_100g"
        case sugars100g = "sugars_100g"
        case sucrose100g = "sucrose_100g"
        case glucose100g = "glucose_100g"
        case fructose100g = "fructose_100g"
        case lactose100g = "lactose_100g"
        case maltose100g = "maltose_100g"
        case maltodextrins100g = "maltodextrins_100g"
        case starch100g = "starch_100g"
        case polyols100g = "polyols_100g"
        case saturatedFat100g = "saturated_fat_100g"
        case butyricAcid100g = "butyric_acid_100g"
        case caproicAcid100g = "caproic_acid_100g"
        case caprylicAcid100g = "caprylic_acid_100g"
        case capricAcid100g = "capric_acid_100g"
        case lauricAcid100g = "lauric_acid_100g"
        case myristicAcid100g = "myristic_acid_100g"
        case palmiticAcid100g = "palmitic_acid_100g"
        case stearicAcid100g = "stearic_acid_100g"
        case arachidicAcid100g = "arachidic_acid_100g"
        case behenicAcid100g = "behenic_acid_100g"
        case lignocericAcid100g = "lignoceric_acid_100g"
        case ceroticAcid100g = "cerotic_acid_100g"
        case montanicAcid100g = "montanic_acid_100g"
        case melissicAcid100g = "melissic_acid_100g"
        case monounsaturatedFat100g = "monounsaturated_fat_100g"
        case polyunsaturatedFat100g = "polyunsaturated_fat_100g"
        case omega3Fat100g = "omega_3_fat_100g"
        case alphaLinolenicAcid100g = "alpha_linolenic_acid_100g"
        case eicosapentaenoicAcid100g = "eicosapentaenoic_acid_100g"
        case docosahexaenoicAcid100g = "docosahexaenoic_acid_100g"
        case omega6Fat100g = "omega_6_fat_100g"
        case linoleicAcid100g = "linoleic_acid_100g"
        case arachidonicAcid100g = "arachidonic_acid_100g"
        case gammaLinolenicAcid100g = "gamma_linolenic_acid_100g"
        case dihomoGammaLinolenicAcid100g = "dihomo_gamma_linolenic_acid_100g"
        case omega9Fat100g = "omega_9_fat_100g"
        case oleicAcid100g = "oleic_acid_100g"
        case elaidicAcid100g = "elaidic_acid_100g"
        case gondoicAcid100g = "gondoic_acid_100g"
        case meadAcid100g = "mead_acid_100g"
        case erucicAcid100g = "erucic_acid_100g"
        case nervonicAcid100g = "nervonic_acid_100g"
        case transFat100g = "trans_fat_100g"
        case cholesterol100g = "cholesterol_100g"
        case fiber100g = "fiber_100g"
        case sodium100g = "sodium_100g"
        case alcohol100g = "alcohol_100g"
        case vitaminA100g = "vitamin_a_100g"
        case vitaminD100g = "vitamin_d_100g"
        case vitaminE100g = "vitamin_e_100g"
        case vitaminK100g = "vitamin_k_100g"
        case vitaminC100g = "vitamin_c_100g"
        case vitaminB1100g = "vitamin_b1_100g"
        case vitaminB2100g = "vitamin_b2_100g"
        case vitaminPp100g = "vitamin_pp_100g"
        case vitaminB6100g = "vitamin_b6_100g"
        case vitaminB9100g = "vitamin_b9_100g"
        case vitaminB12100g = "vitamin_b12_100g"
        case biotin100g = "biotin_100g"
        case pantothenicAcid100g = "pantothenic_acid_100g"
        case silica100g = "silica_100g"
        case bicarbonate100g = "bicarbonate_100g"
        case potassium100g = "potassium_100g"
        case chloride100g = "chloride_100g"
        case calcium100g = "calcium_100g"
        case phosphorus100g = "phosphorus_100g"
        case iron100g = "iron_100g"
        case magnesium100g = "magnesium_100g"
        case zinc100g = "zinc_100g"
        case copper100g = "copper_100g"
        case manganese100g = "manganese_100g"
        case fluoride100g = "fluoride_100g"
        case selenium100g = "selenium_100g"
        case chromium100g = "chromium_100g"
        case molybdenum100g = "molybdenum_100g"
        case iodine100g = "iodine_100g"
        case caffeine100g = "caffeine_100g"
        case taurine100g = "taurine_100g"
    }

}


extension ProductNutriments: SQLModel {
    static let tableName = "product_nutriments"
    
    static let columnsLiteral = CodingKeys.allCases.map(\.rawValue).joined(separator: ",")
    
    static let columns: [String] = CodingKeys.allCases.map(\.rawValue)


    func save(on database: SQLDatabase) async throws {
        try await database.raw("""
        INSERT INTO \(raw: Self.tableName) (
            \(raw: Self.columnsLiteral)
        ) VALUES (
            \(bind: id), \(bind: energy100g), \(bind: proteins100g), \(bind: fat100g),
            \(bind: carbohydrates100g), \(bind: betaCarotene100g), \(bind: salt100g),
            \(bind: casein100g), \(bind: serumProteins100g), \(bind: nucleotides100g),
            \(bind: sugars100g), \(bind: sucrose100g), \(bind: glucose100g),
            \(bind: fructose100g), \(bind: lactose100g), \(bind: maltose100g),
            \(bind: maltodextrins100g), \(bind: starch100g), \(bind: polyols100g),
            \(bind: saturatedFat100g), \(bind: butyricAcid100g), \(bind: caproicAcid100g),
            \(bind: caprylicAcid100g), \(bind: capricAcid100g), \(bind: lauricAcid100g),
            \(bind: myristicAcid100g), \(bind: palmiticAcid100g), \(bind: stearicAcid100g),
            \(bind: arachidicAcid100g), \(bind: behenicAcid100g), \(bind: lignocericAcid100g),
            \(bind: ceroticAcid100g), \(bind: montanicAcid100g), \(bind: melissicAcid100g),
            \(bind: monounsaturatedFat100g), \(bind: polyunsaturatedFat100g),
            \(bind: omega3Fat100g), \(bind: alphaLinolenicAcid100g), \(bind: eicosapentaenoicAcid100g),
            \(bind: docosahexaenoicAcid100g), \(bind: omega6Fat100g), \(bind: linoleicAcid100g),
            \(bind: arachidonicAcid100g), \(bind: gammaLinolenicAcid100g),
            \(bind: dihomoGammaLinolenicAcid100g), \(bind: omega9Fat100g),
            \(bind: oleicAcid100g), \(bind: elaidicAcid100g), \(bind: gondoicAcid100g),
            \(bind: meadAcid100g), \(bind: erucicAcid100g), \(bind: nervonicAcid100g),
            \(bind: transFat100g), \(bind: cholesterol100g), \(bind: fiber100g), \(bind: sodium100g),
            \(bind: alcohol100g), \(bind: vitaminA100g), \(bind: vitaminD100g), \(bind: vitaminE100g),
            \(bind: vitaminK100g), \(bind: vitaminC100g), \(bind: vitaminB1100g), \(bind: vitaminB2100g),
            \(bind: vitaminPp100g), \(bind: vitaminB6100g), \(bind: vitaminB9100g),
            \(bind: vitaminB12100g), \(bind: biotin100g), \(bind: pantothenicAcid100g),
            \(bind: silica100g), \(bind: bicarbonate100g), \(bind: potassium100g),
            \(bind: chloride100g), \(bind: calcium100g), \(bind: phosphorus100g),
            \(bind: iron100g), \(bind: magnesium100g), \(bind: zinc100g), \(bind: copper100g),
            \(bind: manganese100g), \(bind: fluoride100g), \(bind: selenium100g),
            \(bind: chromium100g), \(bind: molybdenum100g), \(bind: iodine100g),
            \(bind: caffeine100g), \(bind: taurine100g)
        )
        """)
        .run()
    }
}
