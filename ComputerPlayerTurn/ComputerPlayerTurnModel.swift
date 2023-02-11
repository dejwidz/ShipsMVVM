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
    func setComputerPlayerPossibleNorth(possibleNorth: [Int])
    func setComputerPlayerPossibleSouth(possibleSouth: [Int])
    func setComputerPlayerPossibleWest(possibleWest: [Int])
    func setComputerPlayerPossibleEast(possibleEast: [Int])
    func computerPlayerClearNorth()
    func computerPlayerClearSouth()
    func computerPlayerClearWest()
    func computerPlayerClearEast()
    func resetEverythingInComputerPlayerWhenShipOfHumanPlayerIsDestroyed()
    func checkHumanPlayerShips()
    func setComputerPlayerNorthIndicator(newNorthIndicator: Bool)
    func setComputerPlayerSouthIndicator(newSouthIndicator: Bool)
    func setComputerPlayerWestIndicator(newWestIndicator: Bool)
    func setComputerPlayerEastIndicator(newEastIndicator: Bool)
}

protocol ComputerPlayerTurnModelDelegate: AnyObject {
    func sendComputerPlayerEnemySea(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, computerPlayerEnemySea: [[Field]])
    func sendHumanPlayerSea(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, humanPlayerSea: [[Field]])
    func sendComputerPlayerHitIndicator(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, hitIndicator: Bool)
    func sendComputerPlayerPossibleNorth(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, possibleNorth: [Int])
    func sendComputerPlayerPossibleSouth(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, possibleSouth: [Int])
    func sendComputerPlayerPossibleWest(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, possibleWest: [Int])
    func sendComputerPlayerPossibleEast(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, possibleEast: [Int])
    func sendHumanPlayerShips(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, ships: [Ship])
    func sendComputerPlayerNorthIndicator(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, currentValueOfNorthIndicator: Bool)
    func sendComputerPlayerSouthIndicator(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, currentValueOfSouthIndicator: Bool)
    func sendComputerPlayerWestIndicator(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, currentValueOfWestIndicator: Bool)
    func sendComputerPlayerEastIndicator(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, currentValueOfEastIndicator: Bool)
}


final class ComputerPlayerTurnModel: ComputerPlayerTurnModelProtocol {
    
    var computerPlayerTurnModelDelegate: ComputerPlayerTurnModelDelegate?
    private var computerPlayer: Player?
    private var humanPlayer: Player? 
    
    init(){
        computerPlayer?.playerDelegate = self
        humanPlayer?.playerDelegate = self
    }
    
    func setComputerPlayer(computerPlayer: Player) {
        self.computerPlayer = computerPlayer
        computerPlayerTurnModelDelegate?.sendComputerPlayerEnemySea(self, computerPlayerEnemySea: computerPlayer.getEnemySea())    }
    
    
    func setHumanPlayer(humanPlayer: Player) {
        self.humanPlayer = humanPlayer
        computerPlayerTurnModelDelegate?.sendHumanPlayerSea(self, humanPlayerSea: humanPlayer.getSea())
        computerPlayerTurnModelDelegate?.sendHumanPlayerShips(self, ships: humanPlayer.getShips())
    }
    
    func setComputerPlayerHitIndicatorTrue() {
        computerPlayer?.setHitIndicator(newValueOfHitIndicator: true)
        computerPlayerTurnModelDelegate?.sendComputerPlayerHitIndicator(self, hitIndicator: (computerPlayer?.getHitIndicator())!)
    }
    
    func setComputerPlayerPossibleNorth(possibleNorth: [Int]) {
        computerPlayer?.setPossibleNorth(possibleNorth: possibleNorth)
        computerPlayerTurnModelDelegate?.sendComputerPlayerPossibleNorth(self, possibleNorth: (computerPlayer?.getPossibleNorth())!)
        }
        
        func setComputerPlayerPossibleSouth(possibleSouth: [Int]) {
            computerPlayer?.setPossibleSouth(possibleSouth: possibleSouth)
            computerPlayerTurnModelDelegate?.sendComputerPlayerPossibleSouth(self, possibleSouth: (computerPlayer?.getPossibleSouth())!)
        }
        
        func setComputerPlayerPossibleWest(possibleWest: [Int]) {
            computerPlayer?.setPossibleWest(possibleWest: possibleWest)
            computerPlayerTurnModelDelegate?.sendComputerPlayerPossibleWest(self, possibleWest: (computerPlayer?.getPossibleWest())!)
        }
        
        func setComputerPlayerPossibleEast(possibleEast: [Int]) {
            computerPlayer?.setPossibleEast(possibleEast: possibleEast)
            computerPlayerTurnModelDelegate?.sendComputerPlayerPossibleEast(self, possibleEast: (computerPlayer?.getPossibleEast())!)
        }
    
       func computerPlayerClearNorth() {
           computerPlayer?.clearNorth()
           computerPlayerTurnModelDelegate?.sendComputerPlayerPossibleNorth(self, possibleNorth: (computerPlayer?.getPossibleNorth())!)
       }
       
       func computerPlayerClearSouth() {
           computerPlayer?.clearSouth()
           computerPlayerTurnModelDelegate?.sendComputerPlayerPossibleSouth(self, possibleSouth: (computerPlayer?.getPossibleSouth())!)
       }
       
       func computerPlayerClearWest() {
           computerPlayer?.clearWest()
           computerPlayerTurnModelDelegate?.sendComputerPlayerPossibleWest(self, possibleWest: (computerPlayer?.getPossibleWest())!)
       }
       
       func computerPlayerClearEast() {
           computerPlayer?.clearEast()
           computerPlayerTurnModelDelegate?.sendComputerPlayerPossibleEast(self, possibleEast: (computerPlayer?.getPossibleEast())!)
       }
    
    func resetEverythingInComputerPlayerWhenShipOfHumanPlayerIsDestroyed() {
        computerPlayer?.setHitIndicator(newValueOfHitIndicator: false)
        computerPlayerTurnModelDelegate?.sendComputerPlayerHitIndicator(self, hitIndicator: (computerPlayer?.getHitIndicator())!)
        computerPlayerClearNorth()
        computerPlayerClearSouth()
        computerPlayerClearWest()
        computerPlayerClearEast()
    }

    func setComputerPlayerEnemySea(newComputerPlayerEnemySea: [[Field]]) {
        computerPlayer?.setEnemySea(newEnemySea: newComputerPlayerEnemySea)
        computerPlayerTurnModelDelegate?.sendComputerPlayerEnemySea(self, computerPlayerEnemySea: (computerPlayer?.getEnemySea())!)
    }
    
    func checkHumanPlayerShips() {
        humanPlayer?.getShips().forEach {$0.checkIfTheShipisStillAlive()}
    }
    
    func setHumanPlayerSea(newSea: [[Field]]) {
        humanPlayer?.setSea(newSea: newSea)
        computerPlayerTurnModelDelegate?.sendHumanPlayerSea(self, humanPlayerSea: (humanPlayer?.getSea())!)
    }
    func setComputerPlayerNorthIndicator(newNorthIndicator: Bool) {
        computerPlayer?.setNorthIndicator(newNorth: newNorthIndicator)
        computerPlayerTurnModelDelegate?.sendComputerPlayerNorthIndicator(self, currentValueOfNorthIndicator: (computerPlayer?.getNorthIndicator())!)
       }
       
       func setComputerPlayerSouthIndicator(newSouthIndicator: Bool) {
           computerPlayer?.setSouthIndicator(newSouth: newSouthIndicator)
           computerPlayerTurnModelDelegate?.sendComputerPlayerSouthIndicator(self, currentValueOfSouthIndicator: (computerPlayer?.getSouthIndicator())!)
       }
       
       func setComputerPlayerWestIndicator(newWestIndicator: Bool) {
           computerPlayer?.setWestIndicator(newWest: newWestIndicator)
           computerPlayerTurnModelDelegate?.sendComputerPlayerWestIndicator(self, currentValueOfWestIndicator: (computerPlayer?.getWestIndicator())!)
       }
       
       func setComputerPlayerEastIndicator(newEastIndicator: Bool) {
           computerPlayer?.setEastIndicator(newEast: newEastIndicator)
           computerPlayerTurnModelDelegate?.sendComputerPlayerEastIndicator(self, currentValueOfEastIndicator: (computerPlayer?.getEastIndicator())!)
       }
}


/*
 PYTANIE
 dlaczego delegata z playera widzi tylko w miejscu gdzie został player zadeklarowany, czyli w modelu creategame, poniższy kod nie działa
 */



extension ComputerPlayerTurnModel: PlayerDelegate {
    func sendMessage(_ player: Player, owner: String, message: String) {
        guard owner == "humanPlayer" else {return}
        computerPlayer?.setHitIndicator(newValueOfHitIndicator: false)
        computerPlayer?.clearNorth()
        computerPlayer?.clearSouth()
        computerPlayer?.clearWest()
        computerPlayer?.clearEast()
    }
    
    func notifyChangesOfPlayer(_ player: Player) {
        self.computerPlayer = player
    }
    
    
}
