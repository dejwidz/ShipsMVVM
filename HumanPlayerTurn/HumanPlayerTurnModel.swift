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
    func sendHumanPlayer(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, humanPlayer: Player)
    func sendMessage(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, message: String)
    func sendHumanPlayerEnemySea(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, humanPlayerEnemySea: [[Field]])
    func sendComputerPlayerSea(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, computerPlayerSea: [[Field]])
    func sendComputerPlayerShips(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, computerPlayerShips: [Ship])
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
        humanPlayerTurnModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer!)
    }
    
    func sendHumanPlayerProperties() {
        humanPlayerTurnModelDelegate?.sendHumanPlayerEnemySea(self, humanPlayerEnemySea: (humanPlayer?.getEnemySea())!)
    }
    
    func updateHumanPlayerEnemySea(newEnemySea: [[Field]]) {
        humanPlayer?.setEnemySea(newEnemySea: newEnemySea)
        humanPlayerTurnModelDelegate?.sendHumanPlayerEnemySea(self, humanPlayerEnemySea: (humanPlayer?.getEnemySea())!)
    }
    
    func updateComputerPlayer(computerPlayer: Player) {
        self.computerPlayer = computerPlayer
        sendComputerPlayerSea()
    }
    
    func sendComputerPlayerSea() {
        humanPlayerTurnModelDelegate?.sendComputerPlayerSea(self, computerPlayerSea: (computerPlayer?.getSea())!)
    }
    
    func updateComputerPlayerSea(newComputerPlayerSea: [[Field]]) {
        computerPlayer?.setSea(newSea: newComputerPlayerSea)
        humanPlayerTurnModelDelegate?.sendComputerPlayerSea(self, computerPlayerSea: (computerPlayer?.getSea())!)
    }
    
    func updateComputerPlayerShips(newShips: [Ship]) {
        computerPlayer?.setShips(newShips: newShips)
        humanPlayerTurnModelDelegate?.sendComputerPlayerShips(self, computerPlayerShips: (computerPlayer?.getShips())!)
    }
    
    func checkComputerPlayerShips() {
        computerPlayer?.getShips().forEach {$0.checkIfTheShipisStillAlive()}
    }
    
    
}

extension HumanPlayerTurnModel: PlayerDelegate {
    func sendMessage(_ player: Player, owner: String, message: String) {
        print(owner, message)
        guard owner == "computerPlayer" else {return}
            humanPlayerTurnModelDelegate?.sendMessage(self, message: message)
    }
    
    func notifyChangesOfPlayer(_ player: Player) {
        print("ZMIANA GRACZA W MODELU")
        self.humanPlayer = player
        humanPlayerTurnModelDelegate?.sendHumanPlayer(self, humanPlayer: player)
    }
    
    
}
