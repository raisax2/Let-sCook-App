//
//  DetailedViewController.swift
//  Let'sCook
//
//  Created by Raisa Methila on 12/4/23.
//

import UIKit

class DetailedViewController: UIViewController {

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

        // Create a UIScrollView to allow scrolling if content is too large
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        // Create a UIStackView inside the UIScrollView
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        let titleLabel = UILabel()
        titleLabel.text = recipe?.label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0 // Allow multiline
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

        // Add labels to the stackView
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(ingredientsLabel)
        stackView.addArrangedSubview(instructionsLabel)

        // Constraints for stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        // Constraints for scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // Adjust priority of the content hugging for titleLabel
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
    }
}
