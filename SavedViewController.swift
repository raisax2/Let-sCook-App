//
//  SavedViewController.swift
//  Let'sCook
//
//  Created by Raisa Methila on 11/20/23.
//

import UIKit

class SavedViewController: UIViewController {

//    private var savedRecipes: [Recipe] = [] // This array will hold the saved recipes
//
//    private let savedRecipesStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 8
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .white
//
//        setupUI()
//    }
//
//    private func setupUI() {
//        view.addSubview(savedRecipesStackView)
//
//        NSLayoutConstraint.activate([
//            savedRecipesStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            savedRecipesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            savedRecipesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            savedRecipesStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ])
//
//        // Load saved recipes from wherever you've saved them (e.g., UserDefaults or CoreData)
//        // You might want to create a SavedRecipesManager for better organization
//        loadSavedRecipes()
//
//        // Update the UI with the saved recipes
//        updateSavedRecipesUI()
//    }
//
//    private func loadSavedRecipes() {
//        // Implement your logic to load saved recipes
//        // For example, you can retrieve them from UserDefaults or CoreData
//        // Populate the `savedRecipes` array with the loaded recipes
//    }
//
//    private func updateSavedRecipesUI() {
//        // Clear existing saved recipes
//        savedRecipesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//
//        // Update with saved recipes
//        for recipe in savedRecipes {
//            let savedRecipeView = SavedRecipeView(recipe: recipe)
//            savedRecipeView.delegate = self
//            savedRecipesStackView.addArrangedSubview(savedRecipeView)
//        }
//    }
//}
//
//extension SavedViewController: SearchResultViewDelegate {
//    func didSelectRecipe(_ recipe: Recipe) {
//        // Handle the selection of a saved recipe if needed
//        // You can navigate to a detailed view or perform any other action
//    }
//}
//
//class SavedRecipeView: UIView {
//
//    private var recipe: Recipe?
//    weak var delegate: SearchResultViewDelegate?
//
//    private let recipeImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    init(recipe: Recipe) {
//        self.recipe = recipe
//        super.init(frame: .zero)
//
//        setupUI()
//
//        titleLabel.text = recipe.label
//
//        // Fetch and set the recipe image
//        if let imageUrl = URL(string: recipe.image) {
//            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
//                if let data = data, error == nil {
//                    DispatchQueue.main.async {
//                        self.recipeImageView.image = UIImage(data: data)
//                    }
//                }
//            }.resume()
//        }
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
//    private func setupUI() {
//        addSubview(recipeImageView)
//        addSubview(titleLabel)
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recipeTapped))
//        addGestureRecognizer(tapGesture)
//
//        NSLayoutConstraint.activate([
//            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
//            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            recipeImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
//            recipeImageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
//            recipeImageView.heightAnchor.constraint(equalTo: recipeImageView.widthAnchor),
//
//            titleLabel.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 0.3),
//            titleLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 5),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
//            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.7),
//        ])
//    }
//
//    @objc private func recipeTapped() {
//        if let recipe = recipe {
//            delegate?.didSelectRecipe(recipe)
//        }
//    }
}
