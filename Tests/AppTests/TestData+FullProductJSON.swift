import Foundation

extension TestData {
    static var fullProductJSON: String { """
{
  "id": "88F14A16-364A-4D82-A327-028B18769194",
  "barcode": 123456789,
  "names": [
    {
      "value": "Demo Product",
      "languageCode": "de-DE"
    }
  ],
  "brands": [
    {
      "value": "Demo Brand",
      "languageCode": "de-DE"
    }
  ],
  "servings": [
    {
      "name": "portion",
      "underlyingQuantity": {
        "unit": "g",
        "value": 100
      }
    }
  ],
  "totalQuantity": {
    "unit": "g",
    "value": 500
  },
  "nutriments": {
    "energy": 200,
    "fats": 10.5,
    "proteins": 5,
    "carbohydrates": 20.0,
    "fatDetails": {
      "saturatedFat": 3.0,
      "butyricAcid": 0.5,
      "caproicAcid": 0.5,
      "caprylicAcid": 0.5,
      "capricAcid": 0.5,
      "lauricAcid": 0.5,
      "myristicAcid": 0.5,
      "palmiticAcid": 0.5,
      "stearicAcid": 0.5,
      "arachidicAcid": 0.5,
      "behenicAcid": 0.5,
      "lignocericAcid": 0.5,
      "ceroticAcid": 0.5,
      "montanicAcid": 0.5,
      "melissicAcid": 0.5,
      "monounsaturatedFat": 1.0,
      "polyunsaturatedFat": 1.0,
      "omega3Fat": 0.5,
      "alphaLinolenicAcid": 0.5,
      "eicosapentaenoicAcid": 0.5,
      "docosahexaenoicAcid": 0.5,
      "omega6Fat": 0.5,
      "linoleicAcid": 0.5,
      "arachidonicAcid": 0.5,
      "gammaLinolenicAcid": 0.5,
      "dihomoGammaLinolenicAcid": 0.5,
      "omega9Fat": 0.5,
      "oleicAcid": 0.5,
      "transFat": 0.5,
      "cholesterol": 0.5,
      "elaidicAcid": 0.5,
      "gondoicAcid": 0.5,
      "meadAcid": 0.5,
      "erucicAcid": 0.5,
      "nervonicAcid": 0.5
    },
    "proteinsDetails": {
      "casein": 1.5,
      "serumProteins": 2.0
    },
    "carbohydratesDetails": {
      "sugars": 15.0,
      "sucrose": 2.0,
      "glucose": 2.0,
      "fructose": 2.0,
      "lactose": 2.0,
      "maltose": 2.0,
      "maltodextrins": 2.0,
      "starch": 5.0,
      "polyols": 1.0
    },
    "vitamins": {
      "vitaminA": 0.001,
      "vitaminB1": 0.001,
      "vitaminB2": 0.001,
      "vitaminPP": 0.001,
      "vitaminB6": 0.001,
      "vitaminB9": 0.001,
      "vitaminB12": 0.001,
      "vitaminC": 0.001,
      "vitaminD": 0.001,
      "vitaminE": 0.001,
      "vitaminK": 0.001,
      "betaCarotene": 0.001,
      "pantothenicAcid": 0.001,
      "biotin": 0.001
    },
    "minerals": {
      "calcium": 0.01,
      "phosphorus": 0.01,
      "iron": 0.01,
      "magnesium": 0.01,
      "zinc": 0.01,
      "copper": 0.01,
      "manganese": 0.01,
      "fluoride": 0.01,
      "selenium": 0.01,
      "iodine": 0.01,
      "chromium": 0.01,
      "molybdenum": 0.01,
      "salt": 0.01,
      "chloride": 0.01,
      "bicarbonate": 0.01,
      "potassium": 0.01,
      "sodium": 0.01,
      "silica": 0.01
    },
    "misc": {
      "caffeine": 0.1,
      "taurine": 0.1,
      "nucleotides": 0.1,
      "fiber": 0.1,
      "alcohol": 0.1
    }
  },
  "verified": true,
  "source": "NutritionPrivacy"
}

"""
    }
}
