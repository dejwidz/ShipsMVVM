//
//  ComputerPlayerTurnViewModel.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 26/05/2022.
//

import Foundation

protocol ComputerPlayerTurnViewModelProtocol: AnyObject {
    var computerPlayerTurnViewModelDelegate: ComputerPlayerTurnViewModelDelegate? {get set}
    func updateComputerPlayerInModel(computerPlayer: Player)
    func sendComputerPlayer()
}

protocol ComputerPlayerTurnViewModelDelegate: AnyObject {
    func sendComputerPlayer(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol, computerPlayer: Player)
}

final class ComputerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol {
    weak var computerPlayerTurnViewModelDelegate: ComputerPlayerTurnViewModelDelegate?
    private var computerPlayer: Player?
    private var model: ComputerPlayerTurnModelProtocol
    
    init(model: ComputerPlayerTurnModelProtocol) {
        self.model = model
        model.computerPlayerTurnModelDelegate = self
    }
    
    
    func updateComputerPlayerInModel(computerPlayer: Player) {
        self.computerPlayer = computerPlayer
        model.updateComputerPlayer(computerPlayer: computerPlayer)
    }
    
    func sendComputerPlayer() {
        computerPlayerTurnViewModelDelegate?.sendComputerPlayer(self, computerPlayer: computerPlayer!)
    }
    
    
}

extension ComputerPlayerTurnViewModel: ComputerPlayerTurnModelDelegate {
    func sendComputerPlayer(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, computerPlayer: Player) {
        print("SENDY VM")

        self.computerPlayer = computerPlayer
        computerPlayerTurnViewModelDelegate?.sendComputerPlayer(self, computerPlayer: computerPlayer)
    }
    
    
}
