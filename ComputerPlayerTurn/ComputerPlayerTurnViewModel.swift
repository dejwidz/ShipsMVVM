//
//  ComputerPlayerTurnViewModel.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 26/05/2022.
//

import Foundation

protocol ComputerPlayerTurnViewModelProtocol: AnyObject {
    var computerPlayerTurnViewModelDelegate: ComputerPlayerTurnViewModelDelegate? {get set}
//    func updateComputerPlayerInModel(computerPlayer: Player)
    func setComputerPlayer(computerPlayer: Player)
    func setHumanPlayer(humanPlayer: Player)
    func computerPlayerShot()
    func setTurnIndicator(currentTurn: turn)
    func resetEverythingWhenHumanPlayerShipHaveBeenDestroyed()
}

protocol ComputerPlayerTurnViewModelDelegate: AnyObject {
    func sendComputerPlayerEnemySea(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol, computerPlayerEnemySea: [[Field]])
    func sayIHaveMissed(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol)
}


final class ComputerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol {
    weak var computerPlayerTurnViewModelDelegate: ComputerPlayerTurnViewModelDelegate?
    private var turnIndicator: turn?
    private var computerPlayerHitIndicator = false {
        didSet {
            print("HIT INDICATOR: \(computerPlayerHitIndicator)")
        }
    }
    private var hitCounter: Int?
//    private var computerPlayer: Player?
//    private var humanPlayer: Player?
    
    private var computerPlayerEnemySea: [[Field]]?
    private var humanPlayerSea: [[Field]]?
    private var computerPlayerPossibleNorth: [Int] {
        didSet {
            print("NORTH  \(computerPlayerPossibleNorth)")
        }
    }
    private var computerPlayerPossibleSouth: [Int] {
        didSet {
            print("SOUTH  \(computerPlayerPossibleSouth)")

        }
    }
    private var computerPlayerPossibleWest: [Int]
    private var computerPlayerPossibleEast: [Int]
    
    
    private var model: ComputerPlayerTurnModelProtocol
    
    
    init(model: ComputerPlayerTurnModelProtocol) {
        self.model = model
        computerPlayerPossibleNorth = []
        computerPlayerPossibleSouth = []
        computerPlayerPossibleWest = []
        computerPlayerPossibleEast = []
        model.computerPlayerTurnModelDelegate = self

    }
    
    
//    func updateComputerPlayerInModel(computerPlayer: Player) {
////        self.computerPlayer = computerPlayer
//        model.setComputerPlayer(computerPlayer: computerPlayer)
//    }
    
    func setComputerPlayer(computerPlayer: Player) {
        model.setComputerPlayer(computerPlayer: computerPlayer)
    }
    
    func setHumanPlayer(humanPlayer: Player) {
//        self.humanPlayer = humanPlayer
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
        let okYouCanShoot = checkIfSurroundingFieldIsFree(row: row, column: column) &&
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
            let index = row ++ column
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
            let index = row ++ column
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
            let index = row ++ column
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
            let index = row ++ column
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
        
        
        guard turnIndicator == .computerPlayerTurn else {return}
        
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
            model.setComputerPlayerEnemySea(newComputerPlayerEnemySea: computerPlayerEnemySea!)
            turnIndicator = .computerPlayerTurn
            if !computerPlayerHitIndicator {
                model.setComputerPlayerHitIndicatorTrue()
                radar(row: row, column: column)
                
            }
            model.checkHumanPlayerShips()
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
        
        print("INSIDE AFTER HIT")
        
        if !computerPlayerPossibleNorth.isEmpty {
            print("INSIDE NORTH")
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
        
        print("NEXT FIELD ",indexOfNextFieldToShot)
        return indexOfNextFieldToShot
    }
    
    func validateLastShot() {
        if !computerPlayerPossibleNorth.isEmpty {
            model.computerPlayerClearNorth()
        }
        else if !computerPlayerPossibleSouth.isEmpty {
            model.computerPlayerClearSouth()
        }
        else if !computerPlayerPossibleWest.isEmpty {
            model.computerPlayerClearWest()
        }
        else if !computerPlayerPossibleEast.isEmpty {
            model.computerPlayerClearEast()
        }
    }
    
}
