//
//  HumanPlayerTurnViewController.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 25/05/2022.
//

import UIKit

class HumanPlayerTurnViewController: UIViewController {
    private var humanPlayer: Player?
    private var viewModel = HumanPlayerTurnViewModel(model: HumanPlayerTurnModel())

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.humanPlayerTurnViewModelDelegate = self
        viewModel.updateHumanPlayerInModel(humanPlayer: humanPlayer!)

      
        
        
        // Do any additional setup after loading the view.
    }

    func setHumanPlayer(humanPlayer: Player) {
        self.humanPlayer = humanPlayer
    }

}

extension HumanPlayerTurnViewController: HumanPlayerTurnViewModelDelegate {
    func sendHumanPlayer(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayer: Player) {
        self.humanPlayer = humanPlayer
    }
    
    
}
