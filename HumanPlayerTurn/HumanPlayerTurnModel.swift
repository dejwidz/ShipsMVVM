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
    
}

protocol HumanPlayerTurnModelDelegate: AnyObject {
    func sendHumanPlayer(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, humanPlayer: Player)
    func sendMessage(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, message: String)
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
    }
    
    func sendHumanPlayer() {
        humanPlayerTurnModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer!)
    }
    
    func updateComputerPlayer(computerPlayer: Player) {
        self.computerPlayer = computerPlayer
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
