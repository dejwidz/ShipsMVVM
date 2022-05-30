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
    func humanPlayerShot(index: Int) -> Bool
}

protocol HumanPlayerTurnViewModelDelegate: AnyObject {
    func sendHumanPlayer(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayer: Player)
    func sendMessage(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, message: String)
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
        model.updateHumanPlayer(humanPlayer: humanPlayer!)
    }
    
    func sendHumanPlayer() {
        humanPlayerTurnViewModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer!)
    }
    
    
}

extension HumanPlayerTurnViewModel: HumanPlayerTurnModelDelegate {
    func sendMessage(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, message: String) {
        humanPlayerTurnViewModelDelegate?.sendMessage(self, message: message)
    }
    
    func sendHumanPlayer(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, humanPlayer: Player) {
        self.humanPlayer = humanPlayer
        humanPlayerTurnViewModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer)
    }
    
    
}

extension HumanPlayerTurnViewModel {
    func humanPlayerShot(index: Int) -> Bool {
        let row = getRow(enter: index)
        let column = getColumn(enter: index)
        var displayComputerViewController = true
//        guard humanPlayer?.getTurnIndicator() == .humanPlayerTurn else {return true}
        if computerPlayer?.getSea()[row][column].getState() == .free {
//            humanPlayer?.setTurnIndicator(newTurnIndicatorValue: .computerPlayerTurn)
//            computerPlayer?.setTurnIndicator(newTurnIndicatorValue: .computerPlayerTurn)
            humanPlayer?.getEnemySea()[row][column].setState(newState: .hit)
            updateHumanPlayerInModel(humanPlayer: humanPlayer!)
            humanPlayerTurnViewModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer!)
            displayComputerViewController = true
        } else {
            computerPlayer?.getSea()[row][column].setState(newState: .hitOccupied)
            humanPlayer?.getEnemySea()[row][column].setState(newState: .hitOccupied)
            computerPlayer?.checkShips()
            humanPlayerTurnViewModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer!)
            updateHumanPlayerInModel(humanPlayer: humanPlayer!)
            displayComputerViewController = false
        }
//        return displayComputerViewController
        return false
    }
}
