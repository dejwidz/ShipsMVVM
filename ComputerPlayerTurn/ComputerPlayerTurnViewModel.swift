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
    func computerPlayerEnemySea(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol, computerPlayerEnemySea: [[Field]])
    func lastShotWasMissedMissed(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol)
    func computerPlayerWon(_ computerPlayerTurnModel: ComputerPlayerTurnViewModelProtocol, message: String)
    func dataForAnimation(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol, indexOfNextFieldToShot: Int, stateOfNextFieldToShot: fieldState)
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
    private var indexOfNextFieldToShot: Int
    
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
        indexOfNextFieldToShot = 0
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
    func humanPlayerShips(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, ships: [Ship]) {
        humanPlayerShips = ships
    }
    
    func computerPlayerHitIndicator(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, hitIndicator: Bool) {
        computerPlayerHitIndicator = hitIndicator
    }
    
    func computerPlayerPossibleFieldsForDirection(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, newFields: [Int], forDirection direction: direction) {
        switch direction {
        case .north:
            computerPlayerPossibleNorth = newFields
        case .south:
            computerPlayerPossibleSouth = newFields
        case .west:
            computerPlayerPossibleWest = newFields
        case .east:
            computerPlayerPossibleEast = newFields
        case .allDirections:
            computerPlayerPossibleNorth = newFields
            computerPlayerPossibleSouth = newFields
            computerPlayerPossibleWest = newFields
            computerPlayerPossibleEast = newFields
        }
    }
    
    func computerPlayerEnemySea(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, computerPlayerEnemySea: [[Field]]) {
        self.computerPlayerEnemySea = computerPlayerEnemySea
        computerPlayerTurnViewModelDelegate?.computerPlayerEnemySea(self, computerPlayerEnemySea: computerPlayerEnemySea)
    }
    
    func humanPlayerSea(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, humanPlayerSea: [[Field]]) {
        self.humanPlayerSea = humanPlayerSea
    }
    
    func computerPlayerIndicatorForDirection(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, newIndicatorValue: Bool, forDirection direction: direction) {
        switch direction {
        case .north:
            computerPlayerNorthIndicator = newIndicatorValue
        case .south:
            computerPlayerSouthIndicator = newIndicatorValue
        case .west:
            computerPlayerWestIndicator = newIndicatorValue
        case .east:
            computerPlayerEastIndicator = newIndicatorValue
        case .allDirections:
            print("nothing")
        }
    }
}

extension ComputerPlayerTurnViewModel {
    
    func saveAccess(row: Int, column: Int) -> Bool {
        let isAccesToThisIndexSave = column >= 0 && column <= 9 && row >= 0 && row <= 9 ? true : false
        return isAccesToThisIndexSave
    }
    
    func isShootingToThisFieldWise(row: Int, column: Int) -> Bool {
        let okYouCanShot = computerPlayerEnemySea![row][column].getState() == .free &&
        checkIfSurroundingFieldIsFree(row: row - 1, column: column - 1) &&
        checkIfSurroundingFieldIsFree(row: row - 1, column: column) &&
        checkIfSurroundingFieldIsFree(row: row - 1, column: column + 1) &&
        checkIfSurroundingFieldIsFree(row: row, column: column - 1) &&
        checkIfSurroundingFieldIsFree(row: row, column: column + 1) &&
        checkIfSurroundingFieldIsFree(row: row + 1, column: column - 1) &&
        checkIfSurroundingFieldIsFree(row: row + 1, column: column) &&
        checkIfSurroundingFieldIsFree(row: row + 1, column: column + 1)
        return okYouCanShot
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
            model.setComputerPlayerPossibleDirection(newPossibleFields: computerPlayerPossibleNorth, forDirection: .north)
            return
        }
        let field = computerPlayerEnemySea![row][column]
        if field.getState() == .free {
            let index = column ++ row
            computerPlayerPossibleNorth.append(index)
            radarNorth(row: row - 1, column: column)
        }
        else {
            model.setComputerPlayerPossibleDirection(newPossibleFields: computerPlayerPossibleNorth, forDirection: .north)
        }
    }
    
    func radarSouth(row: Int, column: Int) {
        guard saveAccess(row: row, column: column) else {
            model.setComputerPlayerPossibleDirection(newPossibleFields: computerPlayerPossibleSouth, forDirection: .south)
            return
        }
        let field = computerPlayerEnemySea![row][column]
        if field.getState() == .free {
            let index = column ++ row
            computerPlayerPossibleSouth.append(index)
            radarSouth(row: row + 1, column: column)
        }
        else {
            model.setComputerPlayerPossibleDirection(newPossibleFields: computerPlayerPossibleSouth, forDirection: .south)
        }
    }
    
    func radarWest(row: Int, column: Int) {
        guard saveAccess(row: row, column: column) else {
            model.setComputerPlayerPossibleDirection(newPossibleFields: computerPlayerPossibleWest, forDirection: .west)
            return
        }
        let field = computerPlayerEnemySea![row][column]
        if field.getState() == .free {
            let index = column ++ row
            computerPlayerPossibleWest.append(index)
            radarWest(row: row, column: column - 1)
        }
        else {
            model.setComputerPlayerPossibleDirection(newPossibleFields: computerPlayerPossibleWest, forDirection: .west)
        }
    }
    
    func radarEast(row: Int, column: Int) {
        guard saveAccess(row: row, column: column) else {
            model.setComputerPlayerPossibleDirection(newPossibleFields: computerPlayerPossibleEast, forDirection: .east)
            return
        }
        let field = computerPlayerEnemySea![row][column]
        if field.getState() == .free {
            let index = column ++ row
            computerPlayerPossibleEast.append(index)
            radarEast(row: row, column: column + 1)
        }
        else {
            model.setComputerPlayerPossibleDirection(newPossibleFields: computerPlayerPossibleEast, forDirection: .east)
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
        let row = getRow(forIndexPathRowValue: nextShotField)
        let column = getColumn(forIndexPathRowValue: nextShotField)
        
        guard turnIndicator == .computerPlayerTurn && gameOverIndicator else {return}
        
        if humanPlayerSea![row][column].getState() == .free {
            computerPlayerTurnViewModelDelegate?.dataForAnimation(self, indexOfNextFieldToShot: indexOfNextFieldToShot, stateOfNextFieldToShot: .free)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.computerPlayerEnemySea![row][column].setState(newState: .hit)
                self.model.setComputerPlayerEnemySea(newComputerPlayerEnemySea: self.computerPlayerEnemySea!)
                self.computerPlayerTurnViewModelDelegate?.lastShotWasMissedMissed(self)
                self.turnIndicator = .humanPlayerTurn
                if self.computerPlayerHitIndicator {
                    self.validateLastShot()
                }
            }
        } else if humanPlayerSea![row][column].getState() == .occupied {
            computerPlayerTurnViewModelDelegate?.dataForAnimation(self, indexOfNextFieldToShot: indexOfNextFieldToShot, stateOfNextFieldToShot: .hitOccupied)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.computerPlayerEnemySea![row][column].setState(newState: .hitOccupied)
                self.humanPlayerSea![row][column].setState(newState: .hitOccupied)
                self.model.setHumanPlayerSea(newSea: self.humanPlayerSea!)
                self.model.setComputerPlayerEnemySea(newComputerPlayerEnemySea: self.computerPlayerEnemySea!)
                self.turnIndicator = .computerPlayerTurn
                self.validateGameOverIndicator()
                if !self.computerPlayerHitIndicator {
                    self.model.setComputerPlayerHitIndicatorTrue()
                    self.radar(row: row, column: column)
                    if !self.computerPlayerPossibleNorth.isEmpty {
                        self.model.setComputerPlayerIndicatorForDirection(newIndicatorValue: true, forDirection: .north)
                    }
                    if !self.computerPlayerPossibleSouth.isEmpty {
                        self.model.setComputerPlayerIndicatorForDirection(newIndicatorValue: true, forDirection: .south)
                    }
                    if !self.computerPlayerPossibleWest.isEmpty {
                        self.model.setComputerPlayerIndicatorForDirection(newIndicatorValue: true, forDirection: .west)
                    }
                    if !self.computerPlayerPossibleEast.isEmpty {
                        self.model.setComputerPlayerIndicatorForDirection(newIndicatorValue: true, forDirection: .east)
                    }
                }
                self.checkShips()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [self] in
                    computerPlayerShot()
                }
            }
        }
    }
    
    func prepareToShot() -> Int {
        if !computerPlayerHitIndicator {
            indexOfNextFieldToShot = iVeGotNothingOnRadar()
        } else {
            indexOfNextFieldToShot = iHaveSomethingOnRadar()
        }
        return indexOfNextFieldToShot
    }
    
    func iVeGotNothingOnRadar() -> Int {
        var nextShotPossibility = false
        while nextShotPossibility == false {
            indexOfNextFieldToShot = Int.random(in: 0...99)
            let row = getRow(forIndexPathRowValue: indexOfNextFieldToShot)
            let column = getColumn(forIndexPathRowValue: indexOfNextFieldToShot)
            nextShotPossibility = isShootingToThisFieldWise(row: row, column: column)
        }
        return indexOfNextFieldToShot
    }
    
    func iHaveSomethingOnRadar() -> Int {
        if !computerPlayerPossibleNorth.isEmpty {
            indexOfNextFieldToShot = computerPlayerPossibleNorth[0]
            computerPlayerPossibleNorth.remove(at: 0)
            model.setComputerPlayerPossibleDirection(newPossibleFields: computerPlayerPossibleNorth, forDirection: .north)
        }
        else if !computerPlayerPossibleSouth.isEmpty {
            indexOfNextFieldToShot = computerPlayerPossibleSouth[0]
            computerPlayerPossibleSouth.remove(at: 0)
            model.setComputerPlayerPossibleDirection(newPossibleFields: computerPlayerPossibleSouth, forDirection: .south)
        }
        else if !computerPlayerPossibleWest.isEmpty {
            indexOfNextFieldToShot = computerPlayerPossibleWest[0]
            computerPlayerPossibleWest.remove(at: 0)
            model.setComputerPlayerPossibleDirection(newPossibleFields: computerPlayerPossibleWest, forDirection: .west)
        }
        else if !computerPlayerPossibleEast.isEmpty {
            indexOfNextFieldToShot = computerPlayerPossibleEast[0]
            computerPlayerPossibleEast.remove(at: 0)
            model.setComputerPlayerPossibleDirection(newPossibleFields: computerPlayerPossibleEast, forDirection: .east)
        }
        return indexOfNextFieldToShot
    }
    
    func validateLastShot() {
        if computerPlayerNorthIndicator {
            model.computerPlayerClearDirection(direction: .north)
            model.setComputerPlayerIndicatorForDirection(newIndicatorValue: false, forDirection: .north)
        }
        else if computerPlayerSouthIndicator {
            model.computerPlayerClearDirection(direction: .south)
            model.setComputerPlayerIndicatorForDirection(newIndicatorValue: false, forDirection: .south)
        }
        else if computerPlayerWestIndicator {
            model.computerPlayerClearDirection(direction: .west)
            model.setComputerPlayerIndicatorForDirection(newIndicatorValue: false, forDirection: .west)
        }
        else if computerPlayerEastIndicator {
            model.computerPlayerClearDirection(direction: .east)
            model.setComputerPlayerIndicatorForDirection(newIndicatorValue: false, forDirection: .east)
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
            computerPlayerTurnViewModelDelegate?.computerPlayerWon(self, message: "You loose")
        }
    }
}
