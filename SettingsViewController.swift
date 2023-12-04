
//
//  SettingsViewController.swift
//  Let'sCook
//
//  Created by Raisa Methila on 11/20/23.
//
import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    private let fontChangeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Font", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.addTarget(SettingsViewController.self, action: #selector(fontChangeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(fontChangeButton)
        
        NSLayoutConstraint.activate([
            fontChangeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fontChangeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            fontChangeButton.widthAnchor.constraint(equalToConstant: 200),
            fontChangeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func fontChangeButtonTapped() {
        let alertController = UIAlertController(title: "Select Font", message: nil, preferredStyle: .actionSheet)
        
        // Add font options
        let systemFontAction = UIAlertAction(title: "System Font", style: .default) { _ in
            self.changeNavigationBarFont(font: UIFont.systemFont(ofSize: 20, weight: .bold))
        }
        
        let boldSystemFontAction = UIAlertAction(title: "Bold System Font", style: .default) { _ in
            self.changeNavigationBarFont(font: UIFont.boldSystemFont(ofSize: 20))
        }
        
        let italicSystemFontAction = UIAlertAction(title: "Italic System Font", style: .default) { _ in
            self.changeNavigationBarFont(font: UIFont.italicSystemFont(ofSize: 20))
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to the alert controller
        alertController.addAction(systemFontAction)
        alertController.addAction(boldSystemFontAction)
        alertController.addAction(italicSystemFontAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    private func changeNavigationBarFont(font: UIFont) {
        if let navController = navigationController {
            let attributes = [NSAttributedString.Key.font: font]
            navController.navigationBar.titleTextAttributes = attributes
        }
    }
}

