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
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MealListResponse.self, from: data)
        return response.meals
    }

    func fetchMealDetails(mealId: String) async throws -> [MealDetail] {
        guard let url = URL(string: MealDBUrlEndpoints.mealDetails.rawValue + mealId) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MealDetailResponse.self, from: data)
        return response.meals
    }
}
