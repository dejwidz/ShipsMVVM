//
//  ViewController.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import UIKit

final class ViewController: UIViewController {
    
    //    @IBAction private func newGameButtonTapped(_ sender: UIButton) {
    //        let vc = CreateGameViewController()
    //        navigationController?.pushViewController(vc, animated: true)
    //    }
    
    private let w = UIScreen.main.bounds.width
    private let h = UIScreen.main.bounds.height
    
    private let newGameButton: UIButton = {
        let button = UIButton()
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        button.setTitle("Start New Game", for: .normal)
        button.setTitleColor(CustomColors.fontColor, for: .normal)
        button.backgroundColor = CustomColors.tealAndGrayblue
        button.layer.cornerRadius = h * 0.025
        button.addTarget(self, action: #selector(newGameButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func newGameButtonTapped(_ sender: UIButton) {
        let vc = CreateGameViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.backColor
        setupInterface()
    }
    
    private func setupInterface() {
        view.addSubview(newGameButton)
        NSLayoutConstraint.activate([
            newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newGameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            newGameButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            newGameButton.heightAnchor.constraint(equalToConstant: h * 0.05)
        ])
    }
}
