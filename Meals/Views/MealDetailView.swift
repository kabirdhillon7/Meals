//
//  MealDetailView.swift
//  Meals
//
//  Created by Kabir Dhillon on 8/6/24.
//

import SwiftUI

struct MealDetailView: View {
    @State private var viewModel: ViewModel

    init(mealId: String) {
        _viewModel = State(initialValue: ViewModel(mealId: mealId))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let mealDetails = viewModel.mealDetails.first {
                    Text(mealDetails.name)
                        .font(.title)
                    Spacer()
                        .frame(height: 20)
                    Text("Instructions:")
                        .fontWeight(.semibold)
                    Text(mealDetails.instructions)
                    Spacer()
                        .frame(height: 10)
                    Text("Ingredients:")
                        .fontWeight(.semibold)
                    ForEach(mealDetails.ingredientMeasurement, id: \.0) { items in
                        HStack {
                            Text(items.0)
                            Spacer()
                            Text(items.1)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .onAppear(perform: {
            Task {
                await viewModel.getMealDetails()
            }
        })
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension MealDetailView {
    @Observable
    final class ViewModel {
        let mealId: String
        var mealDetails = [MealDetail]()
        let apiCaller = MealAPICaller()

        init(mealId: String) {
            self.mealId = mealId
        }

        func getMealDetails() async {
            do {
                mealDetails = try await apiCaller.fetchMealDetails(mealId: mealId)
            } catch {
                print("MealDetailViewModel - error getting meals list: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        MealDetailView(mealId: "52893")
    }
}
