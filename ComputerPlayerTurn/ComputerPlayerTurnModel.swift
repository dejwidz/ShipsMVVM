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
    func updateHumanPlayer(humanPlayer: Player)
    func sendComputerPlayer()
}

protocol ComputerPlayerTurnModelDelegate: AnyObject {
    func sendComputerPlayer(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, computerPlayer: Player)
}


final class ComputerPlayerTurnModel: ComputerPlayerTurnModelProtocol {
   
    var computerPlayerTurnModelDelegate: ComputerPlayerTurnModelDelegate?
    
    private var computerPlayer: Player?
    private var humanPlayer: Player? {
        didSet {
            print("ELO JOŁ")
        }
    }
    
    init(){
        computerPlayer?.playerDelegate = self
        humanPlayer?.playerDelegate = self
    }
    
    func updateComputerPlayer(computerPlayer: Player) {
        self.computerPlayer = computerPlayer
        sendComputerPlayer()
    }
    
    func sendComputerPlayer() {
        computerPlayerTurnModelDelegate?.sendComputerPlayer(self, computerPlayer: computerPlayer!)
    }
    
    func updateHumanPlayer(humanPlayer: Player) {
        self.humanPlayer = humanPlayer
    }
    
    
}

extension ComputerPlayerTurnModel: PlayerDelegate {
    func sendMessage(_ player: Player, owner: String, message: String) {
        guard owner == "humanPlayer" else {return}
        computerPlayer?.setHitIndicator(newValueOfHitIndicator: false)
        computerPlayer?.setFirstHitIndicator(newValueOfFirstHitIndicator: false)
        computerPlayer?.clearNorth()
        computerPlayer?.clearSouth()
        computerPlayer?.clearWest()
        computerPlayer?.clearEast()
        computerPlayer?.setTurnIndicator(newTurnIndicatorValue: .computerPlayerTurn)
    }
    
    func notifyChangesOfPlayer(_ player: Player) {
        self.computerPlayer = player
        computerPlayerTurnModelDelegate?.sendComputerPlayer(self, computerPlayer: player)
    }
    
    
}
