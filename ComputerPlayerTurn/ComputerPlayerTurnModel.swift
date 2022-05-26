//
//  ComputerPlayerTurnModel.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 26/05/2022.
//

import Foundation

protocol ComputerPlayerTurnModelProtocol: AnyObject {
    var computerPlayerTurnModelDelegate: ComputerPlayerTurnModelDelegate? {get set}
    func updateComputerPlayer(computerPlayer: Player)
    func sendComputerPlayer()
}

protocol ComputerPlayerTurnModelDelegate: AnyObject {
    func sendComputerPlayer(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, computerPlayer: Player)
}

final class ComputerPlayerTurnModel: ComputerPlayerTurnModelProtocol {
    
    var computerPlayerTurnModelDelegate: ComputerPlayerTurnModelDelegate?
    
    private var computerPlayer: Player? {
        didSet {
            print("MODEL player set")
        }
    }
    
    init(){
        computerPlayer?.playerDelegate = self
    }
    
    func updateComputerPlayer(computerPlayer: Player) {
        self.computerPlayer = computerPlayer
        sendComputerPlayer()
    }
    
    func sendComputerPlayer() {
        print("MODEL SENDING PLAYER")
        computerPlayerTurnModelDelegate?.sendComputerPlayer(self, computerPlayer: computerPlayer!)
    }
    
    
}

extension ComputerPlayerTurnModel: PlayerDelegate {
    func notifyChangesOfPlayer(_ player: Player) {
        self.computerPlayer = player
        computerPlayerTurnModelDelegate?.sendComputerPlayer(self, computerPlayer: player)
    }
    
    
}
