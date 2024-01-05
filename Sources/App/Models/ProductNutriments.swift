import Fluent
import Foundation
import Vapor

final class ProductNutriments: Model {
    init() {}

    static let schema = "product_nutriments"

    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "id")
    var product: Product

    @Field(key: "energy_100g")
    var energy100g: Int

    @Field(key: "proteins_100g")
    var proteins100g: Int

    @Field(key: "fat_100g")
    var fat100g: Double

    @Field(key: "carbohydrates_100g")
    var carbohydrates100g: Double

    @OptionalField(key: "beta_carotene_100g")
    var betaCarotene100g: Double?

    @OptionalField(key: "salt_100g")
    var salt100g: Double?

    @OptionalField(key: "casein_100g")
    var casein100g: Double?

    @OptionalField(key: "serum_proteins_100g")
    var serumProteins100g: Double?

    @OptionalField(key: "nucleotides_100g")
    var nucleotides100g: Double?

    @OptionalField(key: "sugars_100g")
    var sugars100g: Double?

    @OptionalField(key: "sucrose_100g")
    var sucrose100g: Double?

    @OptionalField(key: "glucose_100g")
    var glucose100g: Double?

    @OptionalField(key: "fructose_100g")
    var fructose100g: Double?

    @OptionalField(key: "lactose_100g")
    var lactose100g: Double?

    @OptionalField(key: "maltose_100g")
    var maltose100g: Double?

    @OptionalField(key: "maltodextrins_100g")
    var maltodextrins100g: Double?

    @OptionalField(key: "starch_100g")
    var starch100g: Double?

    @OptionalField(key: "polyols_100g")
    var polyols100g: Double?

    @OptionalField(key: "saturated_fat_100g")
    var saturatedFat100g: Double?

    @OptionalField(key: "butyric_acid_100g")
    var butyricAcid100g: Double?

    @OptionalField(key: "caproic_acid_100g")
    var caproicAcid100g: Double?

    @OptionalField(key: "caprylic_acid_100g")
    var caprylicAcid100g: Double?

    @OptionalField(key: "capric_acid_100g")
    var capricAcid100g: Double?

    @OptionalField(key: "lauric_acid_100g")
    var lauricAcid100g: Double?

    @OptionalField(key: "myristic_acid_100g")
    var myristicAcid100g: Double?

    @OptionalField(key: "palmitic_acid_100g")
    var palmiticAcid100g: Double?

    @OptionalField(key: "stearic_acid_100g")
    var stearicAcid100g: Double?

    @OptionalField(key: "arachidic_acid_100g")
    var arachidicAcid100g: Double?

    @OptionalField(key: "behenic_acid_100g")
    var behenicAcid100g: Double?

    @OptionalField(key: "lignoceric_acid_100g")
    var lignocericAcid100g: Double?

    @OptionalField(key: "cerotic_acid_100g")
    var ceroticAcid100g: Double?

    @OptionalField(key: "montanic_acid_100g")
    var montanicAcid100g: Double?

    @OptionalField(key: "melissic_acid_100g")
    var melissicAcid100g: Double?

    @OptionalField(key: "monounsaturated_fat_100g")
    var monounsaturatedFat100g: Double?

    @OptionalField(key: "polyunsaturated_fat_100g")
    var polyunsaturatedFat100g: Double?

    @OptionalField(key: "omega_3_fat_100g")
    var omega3Fat100g: Double?

    @OptionalField(key: "alpha_linolenic_acid_100g")
    var alphaLinolenicAcid100g: Double?

    @OptionalField(key: "eicosapentaenoic_acid_100g")
    var eicosapentaenoicAcid100g: Double?

    @OptionalField(key: "docosahexaenoic_acid_100g")
    var docosahexaenoicAcid100g: Double?

    @OptionalField(key: "omega_6_fat_100g")
    var omega6Fat100g: Double?

    @OptionalField(key: "linoleic_acid_100g")
    var linoleicAcid100g: Double?

    @OptionalField(key: "arachidonic_acid_100g")
    var arachidonicAcid100g: Double?

    @OptionalField(key: "gamma_linolenic_acid_100g")
    var gammaLinolenicAcid100g: Double?

    @OptionalField(key: "dihomo_gamma_linolenic_acid_100g")
    var dihomoGammaLinolenicAcid100g: Double?

    @OptionalField(key: "omega_9_fat_100g")
    var omega9Fat100g: Double?

    @OptionalField(key: "oleic_acid_100g")
    var oleicAcid100g: Double?

    @OptionalField(key: "elaidic_acid_100g")
    var elaidicAcid100g: Double?

    @OptionalField(key: "gondoic_acid_100g")
    var gondoicAcid100g: Double?

    @OptionalField(key: "mead_acid_100g")
    var meadAcid100g: Double?

    @OptionalField(key: "erucic_acid_100g")
    var erucicAcid100g: Double?

    @OptionalField(key: "nervonic_acid_100g")
    var nervonicAcid100g: Double?

    @OptionalField(key: "trans_fat_100g")
    var transFat100g: Double?

    @OptionalField(key: "cholesterol_100g")
    var cholesterol100g: Double?

    @OptionalField(key: "fiber_100g")
    var fiber100g: Double?

    @OptionalField(key: "sodium_100g")
    var sodium100g: Double?

    @OptionalField(key: "alcohol_100g")
    var alcohol100g: Double?

    @OptionalField(key: "vitamin_a_100g")
    var vitaminA100g: Double?

    @OptionalField(key: "vitamin_d_100g")
    var vitaminD100g: Double?

    @OptionalField(key: "vitamin_e_100g")
    var vitaminE100g: Double?

    @OptionalField(key: "vitamin_k_100g")
    var vitaminK100g: Double?

    @OptionalField(key: "vitamin_c_100g")
    var vitaminC100g: Double?

    @OptionalField(key: "vitamin_b1_100g")
    var vitaminB1100g: Double?

    @OptionalField(key: "vitamin_b2_100g")
    var vitaminB2100g: Double?

    @OptionalField(key: "vitamin_pp_100g")
    var vitaminPp100g: Double?

    @OptionalField(key: "vitamin_b6_100g")
    var vitaminB6100g: Double?

    @OptionalField(key: "vitamin_b9_100g")
    var vitaminB9100g: Double?

    @OptionalField(key: "vitamin_b12_100g")
    var vitaminB12100g: Double?

    @OptionalField(key: "biotin_100g")
    var biotin100g: Double?

    @OptionalField(key: "pantothenic_acid_100g")
    var pantothenicAcid100g: Double?

    @OptionalField(key: "silica_100g")
    var silica100g: Double?

    @OptionalField(key: "bicarbonate_100g")
    var bicarbonate100g: Double?

    @OptionalField(key: "potassium_100g")
    var potassium100g: Double?

    @OptionalField(key: "chloride_100g")
    var chloride100g: Double?

    @OptionalField(key: "calcium_100g")
    var calcium100g: Double?

    @OptionalField(key: "phosphorus_100g")
    var phosphorus100g: Double?

    @OptionalField(key: "iron_100g")
    var iron100g: Double?

    @OptionalField(key: "magnesium_100g")
    var magnesium100g: Double?

    @OptionalField(key: "zinc_100g")
    var zinc100g: Double?

    @OptionalField(key: "copper_100g")
    var copper100g: Double?

    @OptionalField(key: "manganese_100g")
    var manganese100g: Double?

    @OptionalField(key: "fluoride_100g")
    var fluoride100g: Double?

    @OptionalField(key: "selenium_100g")
    var selenium100g: Double?

    @OptionalField(key: "chromium_100g")
    var chromium100g: Double?

    @OptionalField(key: "molybdenum_100g")
    var molybdenum100g: Double?

    @OptionalField(key: "iodine_100g")
    var iodine100g: Double?

    @OptionalField(key: "caffeine_100g")
    var caffeine100g: Double?

    @OptionalField(key: "taurine_100g")
    var taurine100g: Double?

    init(
        id: UUID? = nil,
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
    ) {
        self.id = id
        self.energy100g = energy100g
        self.proteins100g = proteins100g
        self.fat100g = fat100g
        self.carbohydrates100g = carbohydrates100g
        self.betaCarotene100g = betaCarotene100g
        self.salt100g = salt100g
        self.casein100g = casein100g
        self.serumProteins100g = serumProteins100g
        self.nucleotides100g = nucleotides100g
        self.sugars100g = sugars100g
        self.sucrose100g = sucrose100g
        self.glucose100g = glucose100g
        self.fructose100g = fructose100g
        self.lactose100g = lactose100g
        self.maltose100g = maltose100g
        self.maltodextrins100g = maltodextrins100g
        self.starch100g = starch100g
        self.polyols100g = polyols100g
        self.saturatedFat100g = saturatedFat100g
        self.butyricAcid100g = butyricAcid100g
        self.caproicAcid100g = caproicAcid100g
        self.caprylicAcid100g = caprylicAcid100g
        self.capricAcid100g = capricAcid100g
        self.lauricAcid100g = lauricAcid100g
        self.myristicAcid100g = myristicAcid100g
        self.palmiticAcid100g = palmiticAcid100g
        self.stearicAcid100g = stearicAcid100g
        self.arachidicAcid100g = arachidicAcid100g
        self.behenicAcid100g = behenicAcid100g
        self.lignocericAcid100g = lignocericAcid100g
        self.ceroticAcid100g = ceroticAcid100g
        self.montanicAcid100g = montanicAcid100g
        self.melissicAcid100g = melissicAcid100g
        self.monounsaturatedFat100g = monounsaturatedFat100g
        self.polyunsaturatedFat100g = polyunsaturatedFat100g
        self.omega3Fat100g = omega3Fat100g
        self.alphaLinolenicAcid100g = alphaLinolenicAcid100g
        self.eicosapentaenoicAcid100g = eicosapentaenoicAcid100g
        self.docosahexaenoicAcid100g = docosahexaenoicAcid100g
        self.omega6Fat100g = omega6Fat100g
        self.linoleicAcid100g = linoleicAcid100g
        self.arachidonicAcid100g = arachidonicAcid100g
        self.gammaLinolenicAcid100g = gammaLinolenicAcid100g
        self.dihomoGammaLinolenicAcid100g = dihomoGammaLinolenicAcid100g
        self.omega9Fat100g = omega9Fat100g
        self.oleicAcid100g = oleicAcid100g
        self.elaidicAcid100g = elaidicAcid100g
        self.gondoicAcid100g = gondoicAcid100g
        self.meadAcid100g = meadAcid100g
        self.erucicAcid100g = erucicAcid100g
        self.nervonicAcid100g = nervonicAcid100g
        self.transFat100g = transFat100g
        self.cholesterol100g = cholesterol100g
        self.fiber100g = fiber100g
        self.sodium100g = sodium100g
        self.alcohol100g = alcohol100g
        self.vitaminA100g = vitaminA100g
        self.vitaminD100g = vitaminD100g
        self.vitaminE100g = vitaminE100g
        self.vitaminK100g = vitaminK100g
        self.vitaminC100g = vitaminC100g
        self.vitaminB1100g = vitaminB1100g
        self.vitaminB2100g = vitaminB2100g
        self.vitaminPp100g = vitaminPp100g
        self.vitaminB6100g = vitaminB6100g
        self.vitaminB9100g = vitaminB9100g
        self.vitaminB12100g = vitaminB12100g
        self.biotin100g = biotin100g
        self.pantothenicAcid100g = pantothenicAcid100g
        self.silica100g = silica100g
        self.bicarbonate100g = bicarbonate100g
        self.potassium100g = potassium100g
        self.chloride100g = chloride100g
        self.calcium100g = calcium100g
        self.phosphorus100g = phosphorus100g
        self.iron100g = iron100g
        self.magnesium100g = magnesium100g
        self.zinc100g = zinc100g
        self.copper100g = copper100g
        self.manganese100g = manganese100g
        self.fluoride100g = fluoride100g
        self.selenium100g = selenium100g
        self.chromium100g = chromium100g
        self.molybdenum100g = molybdenum100g
        self.iodine100g = iodine100g
        self.caffeine100g = caffeine100g
        self.taurine100g = taurine100g
    }
}
