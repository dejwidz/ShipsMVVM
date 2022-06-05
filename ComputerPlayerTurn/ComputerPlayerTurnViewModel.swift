//
//  ComputerPlayerTurnViewModel.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 26/05/2022.
//

import Foundation

protocol ComputerPlayerTurnViewModelProtocol: AnyObject {
    var computerPlayerTurnViewModelDelegate: ComputerPlayerTurnViewModelDelegate? {get set}
    func setComputerPlayer(computerPlayer: Player)
    func setHumanPlayer(humanPlayer: Player)
    func computerPlayerShot()
    func setTurnIndicator(currentTurn: turn)
    func resetEverythingWhenHumanPlayerShipHaveBeenDestroyed()
}

protocol ComputerPlayerTurnViewModelDelegate: AnyObject {
    func sendComputerPlayerEnemySea(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol, computerPlayerEnemySea: [[Field]])
    func sayIHaveMissed(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol)
    func sayComputerPlayerWon(_ computerPlayerTurnModel: ComputerPlayerTurnViewModelProtocol, message: String)
}


final class ComputerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol {
    weak var computerPlayerTurnViewModelDelegate: ComputerPlayerTurnViewModelDelegate?
    private var turnIndicator: turn?
    private var computerPlayerHitIndicator = false
    private var hitCounter: Int?
    private var gameOverIndicator: Bool
    private var computerPlayerEnemySea: [[Field]]?
    private var humanPlayerSea: [[Field]]?
    private var computerPlayerPossibleNorth: [Int]
    private var computerPlayerPossibleSouth: [Int]
    private var computerPlayerPossibleWest: [Int]
    private var computerPlayerPossibleEast: [Int]
    private var humanPlayerShips: [Ship]
    private var computerPlayerNorthIndicator: Bool
    private var computerPlayerSouthIndicator: Bool
    private var computerPlayerWestIndicator: Bool
    private var computerPlayerEastIndicator: Bool
    
    private var model: ComputerPlayerTurnModelProtocol
    
    init(model: ComputerPlayerTurnModelProtocol) {
        self.model = model
        computerPlayerPossibleNorth = []
        computerPlayerPossibleSouth = []
        computerPlayerPossibleWest = []
        computerPlayerPossibleEast = []
        humanPlayerShips = []
        computerPlayerNorthIndicator = false
        computerPlayerSouthIndicator = false
        computerPlayerWestIndicator = false
        computerPlayerEastIndicator = false
        gameOverIndicator = true
        model.computerPlayerTurnModelDelegate = self
    }
    
    func setComputerPlayer(computerPlayer: Player) {
        model.setComputerPlayer(computerPlayer: computerPlayer)
    }
    
    func setHumanPlayer(humanPlayer: Player) {
        model.setHumanPlayer(humanPlayer: humanPlayer)
    }
    
    func setTurnIndicator(currentTurn: turn) {
        turnIndicator = currentTurn
    }
    
    func resetEverythingWhenHumanPlayerShipHaveBeenDestroyed() {
        model.resetEverythingInComputerPlayerWhenShipOfHumanPlayerIsDestroyed()
    }
    
}

extension ComputerPlayerTurnViewModel: ComputerPlayerTurnModelDelegate {
    func sendComputerPlayerNorthIndicator(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, currentValueOfNorthIndicator: Bool) {
        computerPlayerNorthIndicator = currentValueOfNorthIndicator
    }
    
    func sendComputerPlayerSouthIndicator(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, currentValueOfSouthIndicator: Bool) {
        computerPlayerSouthIndicator = currentValueOfSouthIndicator
    }
    
    func sendComputerPlayerWestIndicator(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, currentValueOfWestIndicator: Bool) {
        computerPlayerWestIndicator = currentValueOfWestIndicator
    }
    
    func sendComputerPlayerEastIndicator(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, currentValueOfEastIndicator: Bool) {
        computerPlayerEastIndicator = currentValueOfEastIndicator
    }
    
    func sendHumanPlayerShips(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, ships: [Ship]) {
        humanPlayerShips = ships
    }
    
    func sendComputerPlayerHitIndicator(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, hitIndicator: Bool) {
        computerPlayerHitIndicator = hitIndicator
    }
    
    func sendComputerPlayerPossibleNorth(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, possibleNorth: [Int]) {
        computerPlayerPossibleNorth = possibleNorth
    }
    
    func sendComputerPlayerPossibleSouth(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, possibleSouth: [Int]) {
        computerPlayerPossibleSouth = possibleSouth
    }
    
    func sendComputerPlayerPossibleWest(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, possibleWest: [Int]) {
        computerPlayerPossibleWest = possibleWest
    }
    
    func sendComputerPlayerPossibleEast(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, possibleEast: [Int]) {
        computerPlayerPossibleEast = possibleEast
    }
    
    func sendComputerPlayerEnemySea(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, computerPlayerEnemySea: [[Field]]) {
        self.computerPlayerEnemySea = computerPlayerEnemySea
        computerPlayerTurnViewModelDelegate?.sendComputerPlayerEnemySea(self, computerPlayerEnemySea: computerPlayerEnemySea)
    }
    
    func sendHumanPlayerSea(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, humanPlayerSea: [[Field]]) {
        self.humanPlayerSea = humanPlayerSea
    }
}

extension ComputerPlayerTurnViewModel {
    
    func saveAccess(row: Int, column: Int) -> Bool {
        let isAccesToThisIndexSave = column >= 0 && column <= 9 && row >= 0 && row <= 9 ? true : false
        return isAccesToThisIndexSave
    }
    
    func isShootingToThisFieldWise(row: Int, column: Int) -> Bool {
        let okYouCanShoot = computerPlayerEnemySea![row][column].getState() == .free &&
        checkIfSurroundingFieldIsFree(row: row - 1, column: column - 1) &&
        checkIfSurroundingFieldIsFree(row: row - 1, column: column) &&
        checkIfSurroundingFieldIsFree(row: row - 1, column: column + 1) &&
        checkIfSurroundingFieldIsFree(row: row, column: column - 1) &&
        checkIfSurroundingFieldIsFree(row: row, column: column + 1) &&
        checkIfSurroundingFieldIsFree(row: row + 1, column: column - 1) &&
        checkIfSurroundingFieldIsFree(row: row + 1, column: column) &&
        checkIfSurroundingFieldIsFree(row: row + 1, column: column + 1)
        return okYouCanShoot
    }
    
    func checkIfSurroundingFieldIsFree(row: Int, column: Int) -> Bool {
        var okYouCanShot = true
        guard saveAccess(row: row, column: column) else {return okYouCanShot}
        okYouCanShot = computerPlayerEnemySea![row][column].getState() == .free ||
        computerPlayerEnemySea![row][column].getState() == .hit
        return okYouCanShot
    }
    
    func radarNorth(row: Int, column: Int) {
        guard saveAccess(row: row, column: column) else {
            model.setComputerPlayerPossibleNorth(possibleNorth: computerPlayerPossibleNorth ?? [])
            return
        }
        let field = computerPlayerEnemySea![row][column]
        if field.getState() == .free {
            let index = column ++ row
            computerPlayerPossibleNorth.append(index)
            radarNorth(row: row - 1, column: column)
        }
        else {
            model.setComputerPlayerPossibleNorth(possibleNorth: computerPlayerPossibleNorth ?? [])
        }
    }
    
    func radarSouth(row: Int, column: Int) {
        guard saveAccess(row: row, column: column) else {
            model.setComputerPlayerPossibleSouth(possibleSouth: computerPlayerPossibleSouth ?? [])
            return
        }
        let field = computerPlayerEnemySea![row][column]
        if field.getState() == .free {
            let index = column ++ row
            computerPlayerPossibleSouth.append(index)
            radarSouth(row: row + 1, column: column)
        }
        else {
            model.setComputerPlayerPossibleSouth(possibleSouth: computerPlayerPossibleSouth ?? [])
        }
    }
    
    func radarWest(row: Int, column: Int) {
        guard saveAccess(row: row, column: column) else {
            model.setComputerPlayerPossibleWest(possibleWest: computerPlayerPossibleWest ?? [])
            return
        }
        let field = computerPlayerEnemySea![row][column]
        if field.getState() == .free {
            let index = column ++ row
            computerPlayerPossibleWest.append(index)
            radarWest(row: row, column: column - 1)
        }
        else {
            model.setComputerPlayerPossibleWest(possibleWest: computerPlayerPossibleWest ?? [])
        }
    }
    
    func radarEast(row: Int, column: Int) {
        guard saveAccess(row: row, column: column) else {
            model.setComputerPlayerPossibleEast(possibleEast: computerPlayerPossibleEast ?? [])
            return
        }
        let field = computerPlayerEnemySea![row][column]
        if field.getState() == .free {
            let index = column ++ row
            computerPlayerPossibleEast.append(index)
            radarEast(row: row, column: column + 1)
        }
        else {
            model.setComputerPlayerPossibleEast(possibleEast: computerPlayerPossibleEast ?? [])
        }
    }
    
    func radar(row: Int, column: Int) {
        radarNorth(row: row - 1, column: column)
        radarSouth(row: row + 1, column: column)
        radarWest(row: row, column: column - 1)
        radarEast(row: row, column: column + 1)
    }
    
    func computerPlayerShot() {
        let nextShotField = prepareToShot()
        let row = getRow(enter: nextShotField)
        let column = getColumn(enter: nextShotField)
        
        guard turnIndicator == .computerPlayerTurn && gameOverIndicator else {return}
        
        if humanPlayerSea![row][column].getState() == .free {
            computerPlayerEnemySea![row][column].setState(newState: .hit)
            model.setComputerPlayerEnemySea(newComputerPlayerEnemySea: computerPlayerEnemySea!)
            computerPlayerTurnViewModelDelegate?.sayIHaveMissed(self)
            turnIndicator = .humanPlayerTurn
            if computerPlayerHitIndicator {
                validateLastShot()
            }
        } else if humanPlayerSea![row][column].getState() == .occupied {
            computerPlayerEnemySea![row][column].setState(newState: .hitOccupied)
            humanPlayerSea![row][column].setState(newState: .hitOccupied)
            model.setHumanPlayerSea(newSea: humanPlayerSea!)
            model.setComputerPlayerEnemySea(newComputerPlayerEnemySea: computerPlayerEnemySea!)
            turnIndicator = .computerPlayerTurn
            validateGameOverIndicator()
            if !computerPlayerHitIndicator {
                model.setComputerPlayerHitIndicatorTrue()
                radar(row: row, column: column)
                if !computerPlayerPossibleNorth.isEmpty {
                    model.setComputerPlayerNorthIndicator(newNorthIndicator: true)
                }
                if !computerPlayerPossibleSouth.isEmpty {
                    model.setComputerPlayerSouthIndicator(newSouthIndicator: true)
                }
                if !computerPlayerPossibleWest.isEmpty {
                    model.setComputerPlayerWestIndicator(newWestIndicator: true)
                }
                if !computerPlayerPossibleEast.isEmpty {
                    model.setComputerPlayerEastIndicator(newEastIndicator: true)
                }
            }
            checkShips()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [self] in
                computerPlayerShot()
            }
        }
    }
    
    func prepareToShot() -> Int {
           var indexOfNextFieldToShot = 0
           if !computerPlayerHitIndicator {
               indexOfNextFieldToShot = iVeGotNothingOnRadar()
           } else {
               indexOfNextFieldToShot = iHaveSomethingOnRadar()
           }
           return indexOfNextFieldToShot
       }
    
    func iVeGotNothingOnRadar() -> Int {
        var indexOfNextFieldToShot: Int = 0
        var nextShotPossibility = false
        while nextShotPossibility == false {
            indexOfNextFieldToShot = Int.random(in: 0...99)
            let row = getRow(enter: indexOfNextFieldToShot)
            let column = getColumn(enter: indexOfNextFieldToShot)
            nextShotPossibility = isShootingToThisFieldWise(row: row, column: column)
        }
        return indexOfNextFieldToShot
    }
    
    func iHaveSomethingOnRadar() -> Int {
        var indexOfNextFieldToShot = 0
                
        if !computerPlayerPossibleNorth.isEmpty {
            indexOfNextFieldToShot = computerPlayerPossibleNorth[0]
            computerPlayerPossibleNorth.remove(at: 0)
            model.setComputerPlayerPossibleNorth(possibleNorth: computerPlayerPossibleNorth)
        }
        else if !computerPlayerPossibleSouth.isEmpty {
            indexOfNextFieldToShot = computerPlayerPossibleSouth[0]
            computerPlayerPossibleSouth.remove(at: 0)
            model.setComputerPlayerPossibleSouth(possibleSouth: computerPlayerPossibleSouth)
        }
        else if !computerPlayerPossibleWest.isEmpty {
            indexOfNextFieldToShot = computerPlayerPossibleWest[0]
            computerPlayerPossibleWest.remove(at: 0)
            model.setComputerPlayerPossibleWest(possibleWest: computerPlayerPossibleWest)
        }
        else if !computerPlayerPossibleEast.isEmpty {
            indexOfNextFieldToShot = computerPlayerPossibleEast[0]
            computerPlayerPossibleEast.remove(at: 0)
            model.setComputerPlayerPossibleEast(possibleEast: computerPlayerPossibleEast)
        }
        return indexOfNextFieldToShot
    }
    
    func validateLastShot() {
        if computerPlayerNorthIndicator {
            model.computerPlayerClearNorth()
            model.setComputerPlayerNorthIndicator(newNorthIndicator: false)
        }
        else if computerPlayerSouthIndicator {
            model.computerPlayerClearSouth()
            model.setComputerPlayerSouthIndicator(newSouthIndicator: false)
        }
        else if computerPlayerWestIndicator {
            model.computerPlayerClearWest()
            model.setComputerPlayerWestIndicator(newWestIndicator: false)
        }
        else if computerPlayerEastIndicator {
            model.computerPlayerClearEast()
            model.setComputerPlayerEastIndicator(newEastIndicator: false)
        }
    }
    
    func checkShips() {
        humanPlayerShips.forEach {$0.checkIfTheShipisStillAlive()}
    }
    
    func validateGameOverIndicator() {
        hitCounter = 0
        for i in 0...9 {
            for j in 0...9 {
                if computerPlayerEnemySea![i][j].getState() == .hitOccupied {
                    hitCounter! += 1
                }
            }
        }
        if hitCounter! > 16 {
            gameOverIndicator = false
            computerPlayerTurnViewModelDelegate?.sayComputerPlayerWon(self, message: "You loose")
        }
    }
    
}
