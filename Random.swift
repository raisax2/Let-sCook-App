//
//  Random.swift
//  Let'sCook
//
//  Created by Raisa Methila on 11/20/23.
//



import Foundation
import UIKit

class Random: UIViewController {

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

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        let titleLabel = UILabel()
        titleLabel.text = recipe?.label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let instructionsLabel = UILabel()
        instructionsLabel.text = "Recipe Instructions: \n\(recipe?.instructions ?? "No instructions available")"
        instructionsLabel.font = UIFont.systemFont(ofSize: 16)
        instructionsLabel.numberOfLines = 0
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false

        let ingredientsLabel = UILabel()
        ingredientsLabel.text = "Ingredients: \(recipe?.ingredientLines.joined(separator: ", ") ?? "No ingredients available")"
        ingredientsLabel.font = UIFont.systemFont(ofSize: 16)
        ingredientsLabel.numberOfLines = 0
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(ingredientsLabel)
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

        // Set constraints for the stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        // Set constraints for the scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // Set constraints for titleLabel
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
        ])
    }
}
