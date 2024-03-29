//
//  CreateGameViewModel.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation
import UIKit

protocol CreateGameViewModelDelegate: AnyObject {
    func sendComputerPlayer(_ createGameViewModel: CreateGameViewModelProtocol, computerPlayer: Player)
    func sendHumanPlayerSea(_ createGameViewModel: CreateGameViewModelProtocol, humanPlayerSea: [[Field]], humanPlayer: Player)
    func sayNoYouCantDoingLikeThat(_ createGameViewModel: CreateGameViewModelProtocol, message: String)
    func sendMessage(_ createGameViewModel: CreateGameViewModelProtocol, owner: String, message: String)
    func sendInfoAboutDeployingPossibility(_ createGameViewModel: CreateGameViewModelProtocol, info: deploymentPossibility)
    func sendInfoThatStartGameButtonCanAppear(_ createGameViewModel: CreateGameViewModelProtocol)
    func sendInfoForAnimation(_ createGameViewModel: CreateGameViewModelProtocol, rowValueOfIndex: Int, size: Int, orientation: orientation, possibilityIndicator: Bool)
}

protocol CreateGameViewModelProtocol: AnyObject {
    var createGameViewModelDelegate: CreateGameViewModelDelegate? {get set}
    func humanSea()
    func startGamePossibility() -> Bool
    func checkDeployingPossibilityWithoutDeploying(fieldIndex: Int)
    func startGameButtonAppearanceCounter()
}

final class CreateGameViewModel {
    
    weak var createGameViewModelDelegate: CreateGameViewModelDelegate?
    private var model: CreateGameModelProtocol
    var nextShipOrientation: orientation
    var nextShipId: Int
    var nextShipSize: Int
    var column: Int
    var row: Int
    var sea: [[Field]]
    var humanPlayer: Player?
    var computerPlayer: Player?
    var counter: Int
    var startGameAppearanceButtonCounter: Int
    private var rowAndColumnSupplier: RowAndColumnSupplier?
    
    init(model: CreateGameModelProtocol, rowAndColumnSupplier: RowAndColumnSupplier){
        self.model = model
        nextShipId = 2
        nextShipSize = 2
        nextShipOrientation = .vertical
        row = 0
        column = 0
        sea = []
        counter = 0
        startGameAppearanceButtonCounter = 0
        model.createGameModelDelegate = self
        model.sendHumanPlayer()
        model.sendComputerPlayer()
        self.rowAndColumnSupplier = rowAndColumnSupplier
    }
}

extension CreateGameViewModel: CreateGameModelDelegate {
    func message(_ createGameModel: CreateGameModelProtocol, owner: String, message: String) {
        createGameViewModelDelegate?.sendMessage(self, owner: owner, message: message)
    }
    
    func humanPlayer(_ createGameModel: CreateGameModelProtocol, humanPlayer: Player) {
        self.humanPlayer = humanPlayer
    }
    
    func computerPlayer(_ createGameModel: CreateGameModelProtocol, computerPlayer: Player) {
        self.computerPlayer = computerPlayer
        createGameViewModelDelegate?.sendComputerPlayer(self, computerPlayer: computerPlayer)
    }
    
    func humanPlayerSea(_ createGameModel: CreateGameModelProtocol, humanPlayerSea: [[Field]]) {
        sea = humanPlayerSea
        createGameViewModelDelegate?.sendHumanPlayerSea(self, humanPlayerSea: humanPlayerSea, humanPlayer: humanPlayer!)
    }
    
    func startGamePossibility() -> Bool {
        counter = 0
        for row in 0...9 {
            for column in 0...9 {
                if humanPlayer?.getSea()[row][column].getState() == .occupied {
                    counter += 1
                }
            }
        }
        let startGamePossibility = counter == 17
        if !startGamePossibility {
            createGameViewModelDelegate?.sayNoYouCantDoingLikeThat(self, message: "You have to deploy all ships first")
        }
        return startGamePossibility
    }
}

extension CreateGameViewModel: CreateGameViewModelProtocol {
    func humanSea() {
        model.sendHumanPlayerSea()
    }
    
    func checkDeployingPossibility(index: Int, shipId: Int, shipSize: Int, orientation: orientation) {
        let deployPossibility = tryReplaceShip(player: humanPlayer!, field: index, orientation: nextShipOrientation, size: nextShipSize, id: nextShipId)
        
        if !deployPossibility {
            createGameViewModelDelegate?.sayNoYouCantDoingLikeThat(self, message: "You can't deploy ship here")
        }
    }
    
    private func saveAccess(sea: [[Field]], column: Int, row: Int) -> Bool {
        let isAccessToThisIndexSave = column >= 0 && column <= 9 && row >= 0 && row <= 9 ? true : false
        return isAccessToThisIndexSave
    }
    
    private func checkIfFieldIsFree(sea: [[Field]], column: Int, row: Int) -> Bool {
        guard saveAccess(sea: sea, column: column, row: row) else {
            return false
        }
        let fieldIsFree = sea[row][column].getState() == .free &&  checkIfSurroundingFieldsAreFree(sea: sea, column: column, row: row)
        return fieldIsFree
    }
    
    private func checkIfSurroundingFieldIsFree(sea: [[Field]], column: Int,  row: Int) -> Bool {
        var fieldISFree = true
        guard saveAccess(sea: sea, column: column, row: row) else {
            return fieldISFree
        }
        fieldISFree = sea[row][column].getState() == .free
        return fieldISFree
    }
    
    private func checkIfSurroundingFieldsAreFree(sea: [[Field]], column: Int, row: Int) -> Bool {
        let replacingPossibility = checkIfSurroundingFieldIsFree(sea: sea, column: column - 1, row: row - 1) &&
        checkIfSurroundingFieldIsFree(sea: sea, column: column, row: row - 1) &&
        checkIfSurroundingFieldIsFree(sea: sea, column: column + 1, row: row - 1) &&
        checkIfSurroundingFieldIsFree(sea: sea, column: column - 1, row: row) &&
        checkIfSurroundingFieldIsFree(sea: sea, column: column + 1, row: row) &&
        checkIfSurroundingFieldIsFree(sea: sea, column: column - 1, row: row + 1) &&
        checkIfSurroundingFieldIsFree(sea: sea, column: column, row: row + 1) &&
        checkIfSurroundingFieldIsFree(sea: sea, column: column + 1, row: row + 1)
        return replacingPossibility
    }
    
    private func checkVerticalReplacementPossibility(sea: [[Field]], column: Int, row: Int, shipSize: Int) -> Bool {
        var verticalReplacementPossibility = false
        var sizeCounter = 1
        let column = column
        var row = row
        guard shipSize - 1 <= row else {
            verticalReplacementPossibility = false
            return verticalReplacementPossibility
        }
        while sizeCounter <= shipSize {
            verticalReplacementPossibility = checkIfFieldIsFree(sea: sea, column: column, row: row)
            guard verticalReplacementPossibility else {
                return verticalReplacementPossibility
            }
            sizeCounter += 1
            row -= 1
        }
        return verticalReplacementPossibility
    }
    
    private func checkHorizontalReplacementPossibility(sea: [[Field]], column: Int, row: Int, shipSize: Int) -> Bool {
        var horizontalReplacementPossibility = false
        var sizeCounter = 1
        var column = column
        let row = row
        
        guard shipSize <= 10 - column else {
            horizontalReplacementPossibility = false
            return horizontalReplacementPossibility
        }
        while sizeCounter <= shipSize {
            horizontalReplacementPossibility = checkIfFieldIsFree(sea: sea, column: column, row: row)
            guard horizontalReplacementPossibility else {
                return horizontalReplacementPossibility
            }
            sizeCounter += 1
            column += 1
        }
        return horizontalReplacementPossibility
    }
    
    private func placeShipVertically(sea: [[Field]], column: Int, row: Int, size: Int, id: Int, player: Player) {
        var temporaryFields: [Field] = []
        let column = column
        var row = row
        for _ in 0...size - 1 {
            let temporaryField = sea[row][column]
            temporaryFields.append(temporaryField)
            row -= 1
        }
        createShip(player: player, size: size, fields: temporaryFields, id: id)
    }
    
    private func placeShipHorizontally(sea: [[Field]], column: Int, row: Int, size: Int, id: Int, player: Player) {
        var temporaryFields: [Field] = []
        var column = column
        let row = row
        for _ in 0...size - 1 {
            let temporaryField = sea[row][column]
            temporaryFields.append(temporaryField)
            column += 1
        }
        createShip(player: player, size: size, fields: temporaryFields, id: id)
    }
    
    private func createShip(player: Player, size: Int, fields: [Field], id: Int){
        switch id {
        case 2:
            player.setShipFields(id: 2, fields: fields)
        case 3:
            player.setShipFields(id: 3, fields: fields)
        case 32:
            player.setShipFields(id: 32, fields: fields)
        case 4:
            player.setShipFields(id: 4, fields: fields)
        case 5:
            player.setShipFields(id: 5, fields: fields)
        default :
            print("there's no id like that")
        }
        player.actualizeSeaBeforeGame()
    }
    
    private func tryReplaceShip(player: Player, field: Int, orientation: orientation, size: Int, id: Int) -> Bool {
        guard let row = rowAndColumnSupplier?.getRow(forIndexPathRowValue: field) else {
            return false
        }
        guard let column = rowAndColumnSupplier?.getColumn(forIndexPathRowValue: field) else {
            return false
        }
        if orientation == .vertical {
            guard checkVerticalReplacementPossibility(sea: player.getSea(), column: column, row: row, shipSize: size) else {
                return false
            }
            placeShipVertically(sea: player.getSea(), column: column, row: row, size: size, id: id, player: player)
        }
        else {
            guard checkHorizontalReplacementPossibility(sea: player.getSea(), column: column, row: row, shipSize: size) else {
                return false
            }
            placeShipHorizontally(sea: player.getSea(), column: column, row: row, size: size, id: id, player: player)
        }
        return true
    }
    
    func replaceShipsAutomatically(player: Player) {
        player.clearSea()
        var counter = 4
        
        while counter >= 0 {
            replaceAutomatically(player: player, ship: player.getShipAt(index: counter))
            counter -= 1
        }
    }
    
    private func replaceAutomatically(player: Player, ship: Ship) {
        var isPossibleToReplaceShipOnThisField = false
        
        while !isPossibleToReplaceShipOnThisField {
            let field = Int.random(in: 0..<100)
            let orientation: orientation
            let orientationRandomizer = Int.random(in: 0...1)
            if orientationRandomizer == 0 {
                orientation = .vertical
            } else {
                orientation = .horizontal
            }
            
            isPossibleToReplaceShipOnThisField = tryReplaceShip(player: player, field: field, orientation: orientation, size: ship.getSize(), id: ship.getId())
        }
    }
    
    func checkDeployingPossibilityWithoutDeploying(fieldIndex: Int) {
        let deployingPossibility = checkDeployingPossibilityButWithoutDeploying(fieldIndex: fieldIndex)
        if deployingPossibility {
            createGameViewModelDelegate?.sendInfoAboutDeployingPossibility(self, info: .possible)
        }
        else {
            createGameViewModelDelegate?.sendInfoAboutDeployingPossibility(self, info: .impossible)
        }
    }
    
    private func checkDeployingPossibilityButWithoutDeploying(fieldIndex: Int) -> Bool {
        guard let row = rowAndColumnSupplier?.getRow(forIndexPathRowValue: fieldIndex) else {
            return false
        }
        
        guard let column = rowAndColumnSupplier?.getColumn(forIndexPathRowValue: fieldIndex) else {
            return false
        }
        
        var deployingPossibility = true
        
        if nextShipOrientation == .vertical {
            guard checkVerticalReplacementPossibility(sea: (humanPlayer?.getSea())!, column: column, row: row, shipSize: nextShipSize) else {
                deployingPossibility = false
                createGameViewModelDelegate?.sendInfoForAnimation(self, rowValueOfIndex: fieldIndex, size: nextShipSize, orientation: nextShipOrientation, possibilityIndicator: deployingPossibility)
                return deployingPossibility
            }
        }
        else {
            guard checkHorizontalReplacementPossibility(sea: (humanPlayer?.getSea())!, column: column, row: row, shipSize: nextShipSize) else {
                deployingPossibility = false
                createGameViewModelDelegate?.sendInfoForAnimation(self, rowValueOfIndex: fieldIndex, size: nextShipSize, orientation: nextShipOrientation, possibilityIndicator: deployingPossibility)
                return deployingPossibility
            }
        }
        
        createGameViewModelDelegate?.sendInfoForAnimation(self, rowValueOfIndex: fieldIndex, size: nextShipSize, orientation: nextShipOrientation, possibilityIndicator: deployingPossibility)
        return deployingPossibility
    }
    
    func startGameButtonAppearanceCounter() {
        guard startGameAppearanceButtonCounter == 0 else {return}
        for row in 0...9 {
            for column in 0...9 {
                if humanPlayer?.getSea()[row][column].getState() == .occupied {
                    startGameAppearanceButtonCounter += 1
                }
            }
        }
        if startGameAppearanceButtonCounter >= 2 {
            createGameViewModelDelegate?.sendInfoThatStartGameButtonCanAppear(self)
        }
    }
}
