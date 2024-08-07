//
//  MealListView.swift
//  Meals
//
//  Created by Kabir Dhillon on 8/6/24.
//

import SwiftUI

/// A View that displays a list of meal items
struct MealListView: View {
    // MARK: - Properties

    @State private var viewModel = ViewModel()

    // MARK: - View

    var body: some View {
        NavigationStack {
            List(viewModel.meals.sorted(by: { $0.strMeal < $1.strMeal }), id: \.idMeal) { meal in
                HStack {
                    AsyncImage(url: URL(string: meal.strMealThumb)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case let .success(image):
                            image
                                .resizable()
                                .aspectRatio(1.0, contentMode: /*@START_MENU_TOKEN@*/ .fill/*@END_MENU_TOKEN@*/)
                        case .failure:
                            Image(systemName: "carrot")
                                .resizable()
                                .aspectRatio(1.0, contentMode: /*@START_MENU_TOKEN@*/ .fill/*@END_MENU_TOKEN@*/)
                        @unknown default:
                            Image(systemName: "carrot")
                                .resizable()
                                .aspectRatio(1.0, contentMode: /*@START_MENU_TOKEN@*/ .fill/*@END_MENU_TOKEN@*/)
                        }
                    }
                    Text(meal.strMeal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle("Meals")
            .onAppear(perform: {
                Task {
                    await viewModel.getMealsList()
                }
            })
        }
    }
}

extension MealListView {
    /// A View Model for `MealListView`
    @Observable
    final class ViewModel {
        // MARK: - Properties

        private(set) var meals = [Meal]()
        let apiCaller = MealAPICaller()

        // MARK: - Methods

        /// Fetches the list of meals asynchronously
        @MainActor
        func getMealsList() async {
            do {
                meals = try await apiCaller.fetchMealsList()
            } catch {
                print("ContentViewModel - error getting meals list: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    MealListView()
}
