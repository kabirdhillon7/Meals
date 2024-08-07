//
//  Meal.swift
//  Meals
//
//  Created by Kabir Dhillon on 8/6/24.
//

import Foundation

struct MealsResult: Codable {
    let meals: [Meal]
}

struct Meal: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}
