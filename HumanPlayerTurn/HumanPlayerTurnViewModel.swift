//
//  HumanPlayerTurnViewModel.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 25/05/2022.
//

import Foundation

protocol HumanPlayerTurnViewModelProtocol: AnyObject {
    var humanPlayerTurnViewModelDelegate: HumanPlayerTurnViewModelDelegate? {get set}
    func updateHumanPlayerInModel(humanPlayer: Player)
    func updateComputerPlayer(computerPlayer: Player)
    func sendHumanPlayer()
}

protocol HumanPlayerTurnViewModelDelegate: AnyObject {
    func sendHumanPlayer(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayer: Player)
}

final class HumanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol {
    weak var humanPlayerTurnViewModelDelegate: HumanPlayerTurnViewModelDelegate?
    private var humanPlayer: Player?
    private var computerPlayer: Player?
    private var model: HumanPlayerTurnModelProtocol
    
    init(model: HumanPlayerTurnModelProtocol) {
        self.model = model
        model.humanPlayerTurnModelDelegate = self
    }
    
    
    func updateHumanPlayerInModel(humanPlayer: Player) {
        self.humanPlayer = humanPlayer
        model.updateHumanPlayer(humanPlayer: humanPlayer)
    }
    
    func updateComputerPlayer(computerPlayer: Player) {
        self.computerPlayer = computerPlayer
    }
    
    func sendHumanPlayer() {
        humanPlayerTurnViewModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer!)
    }
    
    
}

extension HumanPlayerTurnViewModel: HumanPlayerTurnModelDelegate {
    func sendHumanPlayer(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, humanPlayer: Player) {
        print("SENDY VM")

        self.humanPlayer = humanPlayer
        humanPlayerTurnViewModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer)
    }
    
    
}
