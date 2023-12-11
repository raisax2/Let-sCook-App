//
//  SearchResult.swift
//  Let'sCook
//
//  Created by Raisa Methila on 12/9/23.
//
import Foundation
import UIKit

class SearchResult: UIView {

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
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(frame: .zero)

        setupUI()

        titleLabel.text = recipe.label

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
        addSubview(saveButton)
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

            saveButton.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 0),
            saveButton.widthAnchor.constraint(equalToConstant: 30),
            saveButton.heightAnchor.constraint(equalToConstant: 30),
        ])

        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
    }
    

    @objc private func saveButtonTapped() {
        if let recipe = recipe {
            delegate?.didSaveRecipe(recipe)
            UIView.animate(withDuration: 0.3, animations: {
                self.saveButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.3) {
                    self.saveButton.transform = .identity
                    self.saveButton.tintColor = .green
                }
            }
        }
    }

    @objc private func recipeTapped() {
        if let recipe = recipe {
            delegate?.didSelectRecipe(recipe)
        }
    }
}

