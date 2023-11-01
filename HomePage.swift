//
//  ContentView.swift
//  Let'sCook
//
//  Created by Raisa Methila on 9/25/23.
//


import SwiftUI
import Firebase
import CoreData

struct HomePage: View {
    @State private var navigateToSearch = false
    @State private var navigateToSavedRecipes = false
    @State private var navigateToLastVisitedRecipes = false
    @State private var navigateToSettings = false

    var body: some View {
        NavigationStack {
            VStack {
                // Top Half: Suggested Recipes
                Text("Suggested Recipes").font(.title).padding()
                // Display suggested recipes here.

                // Bottom Half: Buttons
                VStack {
                    HStack {
                        // Button 1: Search with Ingredients
                        ButtonView(title: "Search with Ingredients") {
                            navigateToSearch = true
                        }

                        // Button 2: Saved Recipes
                        ButtonView(title: "Saved Recipes") {
                            navigateToSavedRecipes = true
                        }
                    }

                    HStack {
                        // Button 3: Last Visited Recipes
                        ButtonView(title: "Last Visited Recipes") {
                            navigateToLastVisitedRecipes = true
                        }

                        // Button 4: Settings
                        ButtonView(title: "Settings") {
                            navigateToSettings = true
                        }
                    }
                }
            }
        }
        .navigationDestination(isPresented: $navigateToSearch) {
            Search()
        }
        .navigationDestination(isPresented: $navigateToSavedRecipes) {
            Saved()
        }
        .navigationDestination(isPresented: $navigateToLastVisitedRecipes) {
            LastV()
        }
        .navigationDestination(isPresented: $navigateToSettings) {
            Setting()
        }
    }

    struct ButtonView: View {
        let title: String
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
