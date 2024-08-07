//
//  Meal.swift
//  Meals
//
//  Created by Kabir Dhillon on 8/6/24.
//

import Foundation

struct MealListResponse: Codable {
    let meals: [Meal]
}

struct Meal: Codable {
    let name: String
    let thumbnailString: String
    let id: String

    private enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case thumbnailString = "strMealThumb"
        case id = "idMeal"
    }
}

struct MealDetailResponse: Codable {
    let meals: [MealDetail]
}

struct MealDetail: Codable {
    let name: String
    let instructions: String
    let ingredientMeasurement: [(String, String)]

    private enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case instructions = "strInstructions"
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
        case strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10
        case strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        case strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5
        case strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10
        case strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
        case strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }

    init(name: String, instructions: String, ingredientMeasurement: [(String, String)]) {
        self.name = name
        self.instructions = instructions
        self.ingredientMeasurement = ingredientMeasurement
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        instructions = try container.decode(String.self, forKey: .instructions)

        var ingredientMeasurement = [(String, String)]()
        for index in 1 ... 20 {
            guard let ingredientKey = CodingKeys(stringValue: "strIngredient\(index)") else {
                let description = "Invalid coding key for ingredient \(index)"
                let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: description)
                throw DecodingError.keyNotFound(CodingKeys.strIngredient1, context)
            }

            guard let measurementKey = CodingKeys(stringValue: "strMeasure\(index)") else {
                let description = "Invalid coding key for measurement \(index)"
                let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: description)
                throw DecodingError.keyNotFound(CodingKeys.strMeasure1, context)
            }
            let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey)
            let measurement = try container.decodeIfPresent(String.self, forKey: measurementKey)
            if let ingredient, !ingredient.isEmpty, let measurement, !measurement.isEmpty {
                ingredientMeasurement.append((ingredient, measurement))
            }
        }
        self.ingredientMeasurement = ingredientMeasurement
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        for (index, pair) in ingredientMeasurement.enumerated() {
            if let ingredientKey = CodingKeys(stringValue: "strIngredient\(index + 1)") {
                try container.encode(pair.0, forKey: ingredientKey)
            }
            if let measurementKey = CodingKeys(stringValue: "strMeasure\(index + 1)") {
                try container.encode(pair.1, forKey: measurementKey)
            }
        }
    }
}
