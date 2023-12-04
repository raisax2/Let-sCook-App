//
//  SearchViewController.swift
//  Let'sCook
//
//  Created by Raisa Methila on 11/20/23.
//

import UIKit

class SearchViewController: UIViewController {

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

         // Wrap the existing resultsStackView in a UIScrollView
         view.addSubview(scrollView)
         scrollView.addSubview(resultsStackView)

         setupUI()
     }

    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(excludeTextField)
        view.addSubview(searchButton)

        // Adjust constraints for the scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // Add the resultsStackView to the scrollView
        scrollView.addSubview(resultsStackView)

        // Adjust constraints for resultsStackView within scrollView
        NSLayoutConstraint.activate([
            resultsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            resultsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            resultsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            resultsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            resultsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        // Adjust constraints for other UI elements
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
            // Handle case where ingredients are not provided apple
            return
        }

        let excludeIngredients = excludeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        // Call the API to search for recipes based on ingredients and excludeIngredients
        fetchRecipes(ingredients: ingredients, excludeIngredients: excludeIngredients)
    }

    private func fetchRecipes(ingredients: String, excludeIngredients: String) {
        // Construct the URL with the provided ingredients and excludeIngredients
        let urlString = "https://api.edamam.com/api/recipes/v2?type=public&q=\(ingredients)&excluded=\(excludeIngredients)&app_id=975cbac4&app_key=4df40c8e0831be922abb597a5da68fe9"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        // Perform the API request to fetch recipes
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(EdamamResponse.self, from: data)

                // Update the UI on the main thread with the search results
                DispatchQueue.main.async {
                    self.updateSearchResultsUI(results: result.hits.map { $0.recipe })
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }

    private func updateSearchResultsUI(results: [Recipe]) {
        // Clear existing results
        resultsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Update with new search results
        for recipe in results {
            let resultView = SearchResultView(recipe: recipe)
            resultView.delegate = self
            resultsStackView.addArrangedSubview(resultView)
        }
    }
}

extension SearchViewController: SearchResultViewDelegate {
    func didSelectRecipe(_ recipe: Recipe) {
        let recipeDetailViewController = RecipeDetailViewController(recipe: recipe)
        navigationController?.pushViewController(recipeDetailViewController, animated: true)
    }
}

protocol SearchResultViewDelegate: AnyObject {
    func didSelectRecipe(_ recipe: Recipe)
}

class SearchResultView: UIView {

    private var recipe: Recipe?
    weak var delegate: SearchResultViewDelegate?

    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(frame: .zero)

        setupUI()

        titleLabel.text = recipe.label

        // Fetch and set the recipe image
        if let imageUrl = URL(string: recipe.image) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        self.recipeImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        addSubview(recipeImageView)
        addSubview(titleLabel)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recipeTapped))
        addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            recipeImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.5),

            titleLabel.centerYAnchor.constraint(equalTo: recipeImageView.centerYAnchor), 
            titleLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }


    @objc private func recipeTapped() {
        if let recipe = recipe {
            delegate?.didSelectRecipe(recipe)
        }
    }
}

