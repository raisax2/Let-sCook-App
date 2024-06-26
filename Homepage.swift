//
//  Homepage.swift
//  Let'sCook
//
//  Created by Raisa Methila on 11/20/23.

import Foundation
import UIKit

class Homepage: UIViewController {

    private let edamamAppId = "975cbac4"
    private let edamamAppKey = "4df40c8e0831be922abb597a5da68fe9"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        fetchRandomRecipe()

        // the three buttons in vertical stack lower half of the page
        let searchButton = createSquareButton(title: " Search with Ingredients ", action: #selector(searchButtonTapped))
        let savedRecipesButton = createSquareButton(title: " Saved Recipes ", action: #selector(savedRecipesButtonTapped))

        let buttonsStackView = UIStackView(arrangedSubviews: [searchButton, savedRecipesButton])
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 16
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStackView)

        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.25),
        ])
    }

    // fetch random recipe using edamam API
    private func fetchRandomRecipe() {
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=random&app_id=\(edamamAppId)&app_key=\(edamamAppKey)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // decoding JSON data
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(EdamamResponse.self, from: data)

                // display random recipe on UI
                if let randomRecipe = result.hits.randomElement()?.recipe {
                    DispatchQueue.main.async {
                        self.updateRecipeUI(recipe: randomRecipe)
                    }
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }

    private func updateRecipeUI(recipe: Recipe) {

        let recipeImageView = UIImageView()
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.isUserInteractionEnabled = true
        recipeImageView.recipe = recipe
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recipeImageTapped))
        recipeImageView.addGestureRecognizer(tapGesture)
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recipeImageView)

        if let imageUrl = URL(string: recipe.image) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        recipeImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

        let titleLabel = UILabel()
        titleLabel.text = recipe.label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Set constraints for the title label and the recipe image view
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            recipeImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            recipeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recipeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            recipeImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
        ])
    }

    @objc private func recipeImageTapped(sender: UITapGestureRecognizer) {
        guard let recipeImageView = sender.view as? UIImageView,
              let recipe = recipeImageView.recipe else {
            return
        }

        let randViewController = Random(recipe: recipe)
        navigationController?.pushViewController(randViewController, animated: true)
    }

    private func createSquareButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    // navigating to respective controllers for the 3 buttons
    @objc private func searchButtonTapped() {
        let searchViewController = SearchIngredients()
        navigationController?.pushViewController(searchViewController, animated: true)
    }

    @objc private func savedRecipesButtonTapped() {
        let savedRecipesViewController = Saved()
        navigationController?.pushViewController(savedRecipesViewController, animated: true)
    }
}

struct EdamamResponse: Codable {
    let hits: [Hit]
}

struct Hit: Codable {
    let recipe: Recipe
}

struct Recipe: Codable {
    let label: String
    let image: String
    let instructions: String?
    let ingredientLines: [String]

    // Additional properties
    let healthLabels: [String]?
    let mealType: [String]?
    let cuisineType: [String]?
    let calories: Double?
}

extension UIImageView {
    private static var recipeKey: UInt8 = 0

    var recipe: Recipe? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.recipeKey) as? Recipe
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.recipeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


private struct AssociatedKeys {
    static var recipe = "recipe"
}
