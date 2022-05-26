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
    func sendHumanPlayer()
}

protocol HumanPlayerTurnModelDelegate: AnyObject {
    func sendHumanPlayer(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, humanPlayer: Player)
}

final class HumanPlayerTurnModel: HumanPlayerTurnModelProtocol {
    
    var humanPlayerTurnModelDelegate: HumanPlayerTurnModelDelegate?
    
    private var humanPlayer: Player?
    
    init(){
        humanPlayer?.playerDelegate = self
    }
    
    func updateHumanPlayer(humanPlayer: Player) {
        self.humanPlayer = humanPlayer
        sendHumanPlayer()
    }
    
    func sendHumanPlayer() {
        print("MODEL SENDING PLAYER")
        humanPlayerTurnModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer!)
    }
    
    
}

extension HumanPlayerTurnModel: PlayerDelegate {
    func notifyChangesOfPlayer(_ player: Player) {
        self.humanPlayer = player
        humanPlayerTurnModelDelegate?.sendHumanPlayer(self, humanPlayer: player)
    }
    
    
}
