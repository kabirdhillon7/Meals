//
//  MealAPICaller.swift
//  Meals
//
//  Created by Kabir Dhillon on 8/6/24.
//

import Foundation

enum MealDBUrlEndpoints: String {
    case mealsList = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    case mealDetails = "https://themealdb.com/api/json/v1/1/lookup.php?i="
}

struct MealAPICaller {
    func fetchMealsList() async throws -> [Meal] {
        guard let url = URL(string: MealDBUrlEndpoints.mealsList.rawValue) else {
            return []
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let results = try JSONDecoder().decode(MealsResult.self, from: data)
        return results.meals
    }
}
