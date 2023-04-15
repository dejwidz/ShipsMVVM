//
//  HumanPlayerTurnModel.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 25/05/2022.
//

import Foundation

protocol HumanPlayerTurnModelProtocol: AnyObject {
    var humanPlayerTurnModelDelegate: HumanPlayerTurnModelDelegate? {get set}
    func updateHumanPlayer(humanPlayer: Player)
    func updateComputerPlayer(computerPlayer: Player)
    func sendHumanPlayer()
    func sendHumanPlayerProperties()
    func updateHumanPlayerEnemySea(newEnemySea: [[Field]])
    func sendComputerPlayerSea()
    func updateComputerPlayerSea(newComputerPlayerSea: [[Field]])
    func updateComputerPlayerShips(newShips: [Ship])
    func checkComputerPlayerShips()
}

protocol HumanPlayerTurnModelDelegate: AnyObject {
    func humanPlayer(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, humanPlayer: Player)
    func message(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, message: String)
    func humanPlayerEnemySea(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, humanPlayerEnemySea: [[Field]])
    func computerPlayerSea(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, computerPlayerSea: [[Field]])
    func computerPlayerShips(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, computerPlayerShips: [Ship])
}

final class HumanPlayerTurnModel: HumanPlayerTurnModelProtocol {
    
    var humanPlayerTurnModelDelegate: HumanPlayerTurnModelDelegate?
    private var humanPlayer: Player?
    private var computerPlayer: Player?
    
    init(){
        humanPlayer?.playerDelegate = self
        computerPlayer?.playerDelegate = self
    }
    
    func updateHumanPlayer(humanPlayer: Player) {
        self.humanPlayer = humanPlayer
        sendHumanPlayer()
        sendHumanPlayerProperties()
    }
    
    func sendHumanPlayer() {
        humanPlayerTurnModelDelegate?.humanPlayer(self, humanPlayer: humanPlayer!)
    }
    
    func sendHumanPlayerProperties() {
        humanPlayerTurnModelDelegate?.humanPlayerEnemySea(self, humanPlayerEnemySea: (humanPlayer?.getEnemySea())!)
    }
    
    func updateHumanPlayerEnemySea(newEnemySea: [[Field]]) {
        humanPlayer?.setEnemySea(newEnemySea: newEnemySea)
        humanPlayerTurnModelDelegate?.humanPlayerEnemySea(self, humanPlayerEnemySea: (humanPlayer?.getEnemySea())!)
    }
    
    func updateComputerPlayer(computerPlayer: Player) {
        self.computerPlayer = computerPlayer
        sendComputerPlayerSea()
    }
    
    func sendComputerPlayerSea() {
        humanPlayerTurnModelDelegate?.computerPlayerSea(self, computerPlayerSea: (computerPlayer?.getSea())!)
    }
    
    func updateComputerPlayerSea(newComputerPlayerSea: [[Field]]) {
        computerPlayer?.setSea(newSea: newComputerPlayerSea)
        humanPlayerTurnModelDelegate?.computerPlayerSea(self, computerPlayerSea: (computerPlayer?.getSea())!)
    }
    
    func updateComputerPlayerShips(newShips: [Ship]) {
        computerPlayer?.setShips(newShips: newShips)
        humanPlayerTurnModelDelegate?.computerPlayerShips(self, computerPlayerShips: (computerPlayer?.getShips())!)
    }
    
    func checkComputerPlayerShips() {
        computerPlayer?.getShips().forEach {$0.checkIfTheShipIsStillAlive()}
    }
}

extension HumanPlayerTurnModel: PlayerDelegate {
    func sendMessage(_ player: Player, owner: String, message: String) {
        guard owner == "computerPlayer" else {return}
        humanPlayerTurnModelDelegate?.message(self, message: message)
    }
    
    func notifyChangesOfPlayer(_ player: Player) {
        self.humanPlayer = player
        humanPlayerTurnModelDelegate?.humanPlayer(self, humanPlayer: player)
    }
}
