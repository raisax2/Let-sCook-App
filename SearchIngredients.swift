//
//  SearchIngredients.swift
//  Let'sCook
//
//  Created by Raisa Methila on 11/20/23.
//

import UIKit

class SearchIngredients: UIViewController {

    private var searchResults: [Recipe] = []

    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter ingredients (comma-separated)"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let excludeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Exclude ingredients (comma-separated)"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            return scrollView
        }()

    private let resultsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .white
         view.addSubview(scrollView)
         scrollView.addSubview(resultsStackView)

         setupUI()
     }

    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(excludeTextField)
        view.addSubview(searchButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        scrollView.addSubview(resultsStackView)

        NSLayoutConstraint.activate([
            resultsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            resultsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            resultsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            resultsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            resultsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

 
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            excludeTextField.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            excludeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            excludeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            searchButton.topAnchor.constraint(equalTo: excludeTextField.bottomAnchor, constant: 16),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc private func searchButtonTapped() {
        guard let ingredients = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !ingredients.isEmpty else {
            
            return
        }

        let excludeIngredients = excludeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        fetchRecipes(ingredients: ingredients, excludeIngredients: excludeIngredients)
    }

    private func fetchRecipes(ingredients: String, excludeIngredients: String) {
        let urlString = "https://api.edamam.com/api/recipes/v2?type=public&q=\(ingredients)&excluded=\(excludeIngredients)&app_id=975cbac4&app_key=4df40c8e0831be922abb597a5da68fe9"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(EdamamResponse.self, from: data)

                DispatchQueue.main.async {
                    self.updateSearchResultsUI(results: result.hits.map { $0.recipe })
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }

    private func updateSearchResultsUI(results: [Recipe]) {
        resultsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for recipe in results {
            let resultView = SearchResult(recipe: recipe)
            resultView.delegate = self
            resultsStackView.addArrangedSubview(resultView)
        }
    }
    
    private func saveRecipeToUserDefaults(_ recipe: Recipe) {
            var savedRecipes: [Recipe] = []

            if let savedRecipesData = UserDefaults.standard.data(forKey: "SavedRecipes"),
               let decodedRecipes = try? JSONDecoder().decode([Recipe].self, from: savedRecipesData) {
                savedRecipes = decodedRecipes
            }
            if !savedRecipes.contains(where: { $0.label == recipe.label }) {
                savedRecipes.append(recipe)
                if let encodedData = try? JSONEncoder().encode(savedRecipes) {
                    UserDefaults.standard.set(encodedData, forKey: "SavedRecipes")
                }
            } else {
                print("Recipe already saved: \(recipe.label)")
                
            }
        }
}

protocol SearchResultViewDelegate: AnyObject {
    func didSelectRecipe(_ recipe: Recipe)
    func didSaveRecipe(_ recipe: Recipe)
}

extension SearchIngredients: SearchResultViewDelegate {
    func didSelectRecipe(_ recipe: Recipe) {
        let recipeDetailViewController = RecipeDetail(recipe: recipe)
        navigationController?.pushViewController(recipeDetailViewController, animated: true)
    }

    func didSaveRecipe(_ recipe: Recipe) {
        // NEW: Call the function to save the recipe
        saveRecipeToUserDefaults(recipe)
    }
}




