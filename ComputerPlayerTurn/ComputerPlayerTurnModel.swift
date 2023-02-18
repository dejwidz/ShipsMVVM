//
//  ComputerPlayerTurnModel.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 26/05/2022.
//

import Foundation

protocol ComputerPlayerTurnModelProtocol: AnyObject {
    var computerPlayerTurnModelDelegate: ComputerPlayerTurnModelDelegate? {get set}
    func setComputerPlayer(computerPlayer: Player)
    func setHumanPlayer(humanPlayer: Player)
    func setHumanPlayerSea(newSea: [[Field]])
    func setComputerPlayerEnemySea(newComputerPlayerEnemySea: [[Field]])
    func setComputerPlayerHitIndicatorTrue()
    func setComputerPlayerPossibleDirection(newPossibleFields: [Int], forDirection direction: direction)
    func computerPlayerClearDirection(direction: direction)
    func resetEverythingInComputerPlayerWhenShipOfHumanPlayerIsDestroyed()
    func checkHumanPlayerShips()
    func setComputerPlayerIndicatorForDirection(newIndicatorValue: Bool, forDirection direction: direction)
}

protocol ComputerPlayerTurnModelDelegate: AnyObject {
    func computerPlayerEnemySea(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, computerPlayerEnemySea: [[Field]])
    func humanPlayerSea(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, humanPlayerSea: [[Field]])
    func computerPlayerHitIndicator(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, hitIndicator: Bool)
    func computerPlayerPossibleFieldsForDirection(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, newFields: [Int], forDirection direction: direction)
    func humanPlayerShips(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, ships: [Ship])
    func computerPlayerIndicatorForDirection(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, newIndicatorValue: Bool, forDirection direction: direction)
}

final class ComputerPlayerTurnModel: ComputerPlayerTurnModelProtocol {
    
    var computerPlayerTurnModelDelegate: ComputerPlayerTurnModelDelegate?
    private var computerPlayer: Player?
    private var humanPlayer: Player?
    
    func setComputerPlayer(computerPlayer: Player) {
        self.computerPlayer = computerPlayer
        computerPlayerTurnModelDelegate?.computerPlayerEnemySea(self, computerPlayerEnemySea: computerPlayer.getEnemySea())
    }
    
    func setHumanPlayer(humanPlayer: Player) {
        self.humanPlayer = humanPlayer
        computerPlayerTurnModelDelegate?.humanPlayerSea(self, humanPlayerSea: humanPlayer.getSea())
        computerPlayerTurnModelDelegate?.humanPlayerShips(self, ships: humanPlayer.getShips())
    }
    
    func setComputerPlayerHitIndicatorTrue() {
        computerPlayer?.setHitIndicator(newValueOfHitIndicator: true)
        computerPlayerTurnModelDelegate?.computerPlayerHitIndicator(self, hitIndicator: (computerPlayer?.getHitIndicator())!)
    }
    
    func setComputerPlayerPossibleDirection(newPossibleFields: [Int], forDirection direction: direction) {
        computerPlayer?.setPossibleDirection(direction: direction, possibleFields: newPossibleFields)
        computerPlayerTurnModelDelegate?.computerPlayerPossibleFieldsForDirection(self, newFields: (computerPlayer?.getPossibleDirection(direction: direction))!, forDirection: direction)
    }
    
    func computerPlayerClearDirection(direction: direction) {
        computerPlayer?.clearDirection(direction: direction)
        computerPlayerTurnModelDelegate?.computerPlayerPossibleFieldsForDirection(self, newFields: (computerPlayer?.getPossibleDirection(direction: direction))!, forDirection: direction)
    }
    
    func resetEverythingInComputerPlayerWhenShipOfHumanPlayerIsDestroyed() {
        computerPlayer?.setHitIndicator(newValueOfHitIndicator: false)
        computerPlayerTurnModelDelegate?.computerPlayerHitIndicator(self, hitIndicator: (computerPlayer?.getHitIndicator())!)
        computerPlayerClearDirection(direction: .allDirections)
    }
    
    func setComputerPlayerEnemySea(newComputerPlayerEnemySea: [[Field]]) {
        computerPlayer?.setEnemySea(newEnemySea: newComputerPlayerEnemySea)
        computerPlayerTurnModelDelegate?.computerPlayerEnemySea(self, computerPlayerEnemySea: (computerPlayer?.getEnemySea())!)
    }
    
    func checkHumanPlayerShips() {
        humanPlayer?.getShips().forEach {$0.checkIfTheShipisStillAlive()}
    }
    
    func setHumanPlayerSea(newSea: [[Field]]) {
        humanPlayer?.setSea(newSea: newSea)
        computerPlayerTurnModelDelegate?.humanPlayerSea(self, humanPlayerSea: (humanPlayer?.getSea())!)
    }
    
    func setComputerPlayerIndicatorForDirection(newIndicatorValue: Bool, forDirection direction: direction) {
        computerPlayer?.setIndicator(direction: direction, newIndicatorValue: newIndicatorValue)
        computerPlayerTurnModelDelegate?.computerPlayerIndicatorForDirection(self, newIndicatorValue: ((computerPlayer?.getIndicator(direction: direction))!), forDirection: direction)
    }
}
