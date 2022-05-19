//
//  ViewController.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction private func newGameButtonTapped(_ sender: UIButton) {
        let vc = CreateGameViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
