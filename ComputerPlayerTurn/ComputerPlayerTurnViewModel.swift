//
//  ComputerPlayerTurnViewModel.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 26/05/2022.
//

import Foundation

protocol ComputerPlayerTurnViewModelProtocol: AnyObject {
    var computerPlayerTurnViewModelDelegate: ComputerPlayerTurnViewModelDelegate? {get set}
    func updateComputerPlayerInModel(computerPlayer: Player)
    func sendComputerPlayer()
    func setHumanPlayer(humanPlayer: Player)
    func computerPlayerShot()
}

protocol ComputerPlayerTurnViewModelDelegate: AnyObject {
    func sendComputerPlayer(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol, computerPlayer: Player)
}

final class ComputerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol {
    weak var computerPlayerTurnViewModelDelegate: ComputerPlayerTurnViewModelDelegate?
    private var computerPlayer: Player?
    private var humanPlayer: Player?
    private var model: ComputerPlayerTurnModelProtocol
    
    
    init(model: ComputerPlayerTurnModelProtocol) {
        self.model = model
        model.computerPlayerTurnModelDelegate = self
    }
    
    
    func updateComputerPlayerInModel(computerPlayer: Player) {
        self.computerPlayer = computerPlayer
        model.updateComputerPlayer(computerPlayer: computerPlayer)
    }
    
    func sendComputerPlayer() {
        computerPlayerTurnViewModelDelegate?.sendComputerPlayer(self, computerPlayer: computerPlayer!)
    }
    
    func setHumanPlayer(humanPlayer: Player) {
        self.humanPlayer = humanPlayer
        model.updateHumanPlayer(humanPlayer: humanPlayer)
    }
    
}

extension ComputerPlayerTurnViewModel: ComputerPlayerTurnModelDelegate {
    func sendComputerPlayer(_ computerPlayerTurnModel: ComputerPlayerTurnModelProtocol, computerPlayer: Player) {
        self.computerPlayer = computerPlayer
        computerPlayerTurnViewModelDelegate?.sendComputerPlayer(self, computerPlayer: computerPlayer)
    }
    
    
}

extension ComputerPlayerTurnViewModel {
    func computerPlayerShot() {
        
    }
    
    func prepareToShot() -> Int {
        var indexOfNextFieldToShot = 0
        if !(computerPlayer?.getHitIndicator())! {
            indexOfNextFieldToShot = iVeGotNothingOnRadar()
        } else {
            
        }
        return indexOfNextFieldToShot
    }
    
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
        okYouCanShot = computerPlayer?.getEnemySea()[row][column].getState() == .free ||
        computerPlayer?.getEnemySea()[row][column].getState() == .hit
        return okYouCanShot
    }
    
    func combineTwoIntegersIntoOne(firstOne: Int, secondOne: Int) -> Int {
        let firstString = "\(firstOne)"
        let secondString = "\(secondOne)"
        let combinedString = firstString + secondString
        let combinedInteger = Int(combinedString)
        return combinedInteger!
    }
    
    func radarNorth(row: Int, column: Int) {
        guard saveAccess(row: row, column: column) else {return}
        let field = computerPlayer?.getEnemySea()[row][column]
        if field!.getState() == .free {
            let index = combineTwoIntegersIntoOne(firstOne: row, secondOne: column)
            computerPlayer?.addFieldToPossibleNorth(fieldIndex: index)
            radarNorth(row: row - 1, column: column)
        }
    }
    
    func radarSouth(row: Int, column: Int) {
        guard saveAccess(row: row, column: column) else {return}
        let field = computerPlayer?.getEnemySea()[row][column]
        if field!.getState() == .free {
            let index = combineTwoIntegersIntoOne(firstOne: row, secondOne: column)
            computerPlayer?.addFieldToPossibleSouth(fieldIndex: index)
            radarSouth(row: row + 1, column: column)
        }
    }
    
    func radarWest(row: Int, column: Int) {
        guard saveAccess(row: row, column: column) else {return}
        let field = computerPlayer?.getEnemySea()[row][column]
        if field!.getState() == .free {
            let index = combineTwoIntegersIntoOne(firstOne: row, secondOne: column)
            computerPlayer?.addFieldToPossibleWest(fieldIndex: index)
            radarWest(row: row, column: column - 1)
        }
    }
    
    func radarEast(row: Int, column: Int) {
        guard saveAccess(row: row, column: column) else {return}
        let field = computerPlayer?.getEnemySea()[row][column]
        if field!.getState() == .free {
            let index = combineTwoIntegersIntoOne(firstOne: row, secondOne: column)
            computerPlayer?.addFieldToPossibleEast(fieldIndex: index)
            radarEast(row: row, column: column + 1)
        }
    }
    
    func radar(row: Int, column: Int) {
        radarNorth(row: row - 1, column: column)
        radarSouth(row: row + 1, column: column)
        radarWest(row: row, column: column - 1)
        radarEast(row: row, column: column + 1)
    }
    
    func iVeGotNothingOnRadar() -> Int {
        var indexOfNextFieldToShot: Int = 0
        var nextShotPossibility = false
        while nextShotPossibility == false {
            indexOfNextFieldToShot = Int.random(in: 0...99)
            var row = getRow(enter: indexOfNextFieldToShot)
            var column = getColumn(enter: indexOfNextFieldToShot)
            nextShotPossibility = isShootingToThisFieldWise(row: row, column: column)
        }
        return indexOfNextFieldToShot
    }
    
}
