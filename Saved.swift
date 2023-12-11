//
//  Saved.swift
//  Let'sCook
//
//  Created by Raisa Methila on 11/20/23.
//


import UIKit

class Saved: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SavedRecipeCell.self, forCellReuseIdentifier: SavedRecipeCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var savedRecipes: [Recipe] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Saved Recipes"

        setupTableView()
        fetchSavedRecipes()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func fetchSavedRecipes() {
        if let savedRecipesData = UserDefaults.standard.data(forKey: "SavedRecipes"),
           let decodedRecipes = try? JSONDecoder().decode([Recipe].self, from: savedRecipesData) {
            savedRecipes = decodedRecipes
            tableView.reloadData()
        }
    }
}

extension Saved: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SavedRecipeCell.reuseIdentifier, for: indexPath) as! SavedRecipeCell
        let recipe = savedRecipes[indexPath.row]
        cell.configure(with: recipe)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = savedRecipes[indexPath.row]
        let detailViewController = RecipeDetail(recipe: selectedRecipe)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
