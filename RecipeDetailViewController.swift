//
//  DetailViewController.swift
//  Let'sCook
//
//  Created by Raisa Methila on 12/4/23.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    private var recipe: Recipe?

    init(recipe: Recipe) {
        super.init(nibName: nil, bundle: nil)
        self.recipe = recipe
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = recipe?.label

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
        if let imageUrl = URL(string: recipe?.image ?? "") {
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        recipeImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

        // Create a stack view to organize UI elements vertically
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)

        // Add labels to the stackView
        stackView.addArrangedSubview(recipeImageView)

        // Add title label
        let titleLabel = UILabel()
        titleLabel.text = recipe?.label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0 // Allow multiline
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)

        // Add ingredients label
        let ingredientsLabel = UILabel()
        ingredientsLabel.text = "Ingredients: \(recipe?.ingredientLines.joined(separator: ", ") ?? "No ingredients available")"
        ingredientsLabel.font = UIFont.systemFont(ofSize: 16)
        ingredientsLabel.numberOfLines = 0
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(ingredientsLabel)

        // Add instructions label
        let instructionsLabel = UILabel()
        instructionsLabel.text = "Recipe Instructions: \n\(recipe?.instructions ?? "No instructions available")"
        instructionsLabel.font = UIFont.systemFont(ofSize: 16)
        instructionsLabel.numberOfLines = 0
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(instructionsLabel)

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

    @objc private func recipeImageTapped() {
        guard let recipeImageView = view.subviews.compactMap({ $0 as? UIImageView }).first,
              let recipe = recipeImageView.recipe else {
            return
        }

        let randViewController = RandViewController(recipe: recipe)
        navigationController?.pushViewController(randViewController, animated: true)
    }
}