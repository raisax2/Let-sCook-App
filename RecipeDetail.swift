//
//  RecipeDetails.swift
//  Let'sCook
//
//  Created by Raisa Methila on 12/4/23.
//

import UIKit

class RecipeDetail: UIViewController {

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

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)

        let recipeImageView = UIImageView()
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.isUserInteractionEnabled = true
        recipeImageView.recipe = recipe
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recipeImageTapped))
        recipeImageView.addGestureRecognizer(tapGesture)
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(recipeImageView)

        if let imageUrl = URL(string: recipe?.image ?? "") {
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        recipeImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)

        let titleLabel = UILabel()
        titleLabel.text = recipe?.label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0 // Allow multiline
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)

        let ingredientsLabel = UILabel()
        ingredientsLabel.text = "Ingredients: \(recipe?.ingredientLines.joined(separator: ", ") ?? "No ingredients available")"
        ingredientsLabel.font = UIFont.systemFont(ofSize: 16)
        ingredientsLabel.numberOfLines = 0
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(ingredientsLabel)

        let instructionsLabel = UILabel()
        instructionsLabel.text = "Recipe Instructions: \n\(recipe?.instructions ?? "No instructions available")"
        instructionsLabel.font = UIFont.systemFont(ofSize: 16)
        instructionsLabel.numberOfLines = 0
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(instructionsLabel)

        // Additional Information Labels
        if let healthLabels = recipe?.healthLabels, !healthLabels.isEmpty {
            let healthLabelsLabel = UILabel()
            healthLabelsLabel.text = "Health Labels: \(healthLabels.joined(separator: ", "))"
            healthLabelsLabel.font = UIFont.systemFont(ofSize: 16)
            healthLabelsLabel.numberOfLines = 0
            healthLabelsLabel.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(healthLabelsLabel)
        }

        if let mealType = recipe?.mealType, !mealType.isEmpty {
            let mealTypeLabel = UILabel()
            mealTypeLabel.text = "Meal Type: \(mealType.joined(separator: ", "))"
            mealTypeLabel.font = UIFont.systemFont(ofSize: 16)
            mealTypeLabel.numberOfLines = 0
            mealTypeLabel.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(mealTypeLabel)
        }

        if let cuisineType = recipe?.cuisineType, !cuisineType.isEmpty {
            let cuisineTypeLabel = UILabel()
            cuisineTypeLabel.text = "Cuisine Type: \(cuisineType.joined(separator: ", "))"
            cuisineTypeLabel.font = UIFont.systemFont(ofSize: 16)
            cuisineTypeLabel.numberOfLines = 0
            cuisineTypeLabel.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(cuisineTypeLabel)
        }

        if let calories = recipe?.calories {
            let caloriesLabel = UILabel()
            caloriesLabel.text = "Calories: \(calories)"
            caloriesLabel.font = UIFont.systemFont(ofSize: 16)
            caloriesLabel.numberOfLines = 0
            caloriesLabel.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(caloriesLabel)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

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

        let randViewController = Random(recipe: recipe)
        navigationController?.pushViewController(randViewController, animated: true)
    }
}
