//
//  HomepageViewController.swift
//  Let'sCook
//
//  Created by Raisa Methila on 11/20/23.
//

import Foundation
import UIKit

class HomepageViewController: UIViewController {

    private let edamamAppId = "975cbac4"
    private let edamamAppKey = "4df40c8e0831be922abb597a5da68fe9"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Fetch a random recipe from Edamam API
        fetchRandomRecipe()

       
        let searchButton = createSquareButton(title: " Search with Ingredients ", action: #selector(searchButtonTapped))
        let savedRecipesButton = createSquareButton(title: " Saved Recipes ", action: #selector(savedRecipesButtonTapped))
        let settingsButton = createSquareButton(title: " Settings ", action: #selector(settingsButtonTapped))

        let buttonsStackView = UIStackView(arrangedSubviews: [searchButton, savedRecipesButton, settingsButton])
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 16
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStackView)

        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * 0.25),
        ])
    }

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

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(EdamamResponse.self, from: data)

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

    private var stackView: UIStackView!

    private func updateRecipeUI(recipe: Recipe) {
        // Create a container view to hold both the image and stackView
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // Create recipe image view
        let recipeImageView = UIImageView()
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.isUserInteractionEnabled = true
        recipeImageView.recipe = recipe
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recipeImageTapped))
        recipeImageView.addGestureRecognizer(tapGesture)
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(recipeImageView)

        // Fetch and set the recipe image
        if let imageUrl = URL(string: recipe.image) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        recipeImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

        // Create a stack view to organize UI elements vertically
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)

        // Add labels to the stackView
        stackView.addArrangedSubview(recipeImageView)

        // Add title label
        let titleLabel = UILabel()
        titleLabel.text = recipe.label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0 // Allow multiline
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)

        // Constraints for container view
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
        ])

        // Constraints for stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        // Constraints for recipeImageView
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
        ])
    }


    @objc private func recipeImageTapped(sender: UITapGestureRecognizer) {
        guard let recipeImageView = sender.view as? UIImageView,
              let recipe = recipeImageView.recipe else {
            return
        }

        let randViewController = RandViewController(recipe: recipe)
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

  
    @objc private func searchButtonTapped() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }

    @objc private func savedRecipesButtonTapped() {
        let savedRecipesViewController = SavedViewController()
        navigationController?.pushViewController(savedRecipesViewController, animated: true)
    }

    @objc private func settingsButtonTapped() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
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


