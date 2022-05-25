//
//  CreateGameViewModel.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation
import UIKit

protocol CreateGameViewModelDelegate: AnyObject {
    func sendHumanPlayerSea(_ createGameViewModel: CreateGameViewModelProtocol, humanPlayerSea: [[Field]])
}

protocol CreateGameViewModelProtocol: AnyObject {
    var createGameViewModelDelegate: CreateGameViewModelDelegate? {get set}
    func sendHumanSea()
}

final class CreateGameViewModel: CreateGameViewModelProtocol {
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
    
    init(model: CreateGameModelProtocol){
        self.model = model
        nextShipId = 2
        nextShipSize = 2
        nextShipOrientation = .vertical
        row = 0
        column = 0
        sea = []
        model.createGameModelDelegate = self
        model.sendHumanPlayer()
        model.sendComputerPlayer()
        
    }
    
    func sendHumanSea() {
        model.sendHumanPlayerSea()
        
    }
}

extension CreateGameViewModel: CreateGameModelDelegate {
    func sendHumanPlayer(_ createGameModel: CreateGameModelProtocol, humanPlayer: Player) {
        self.humanPlayer = humanPlayer
        
    }
    
    func sendComputerPlayer(_ createGameModel: CreateGameModelProtocol, computerPlayer: Player) {
        self.computerPlayer = computerPlayer
    }
    
    func sendHumanPlayerSea(_ createGameModel: CreateGameModelProtocol, humanPlayerSea: [[Field]]) {
        sea = humanPlayerSea
        createGameViewModelDelegate?.sendHumanPlayerSea(self, humanPlayerSea: humanPlayerSea)
    }
    
    
}

extension CreateGameViewModel {
    
    func checkDeployingPossibility(index: Int, shipId: Int, shipSize: Int, orientation: orientation) {
        tryReplaceShip(player: humanPlayer!, field: index, orientation: nextShipOrientation, size: nextShipSize, id: nextShipId)
    // DOPISAC KOMUNIKAT O NIEMOZLIWOSCI I WYSLAC DELEGATEM
    }

    func saveAcces(sea: [[Field]], column: Int, row: Int) -> Bool {
        let isAccesToThisIndexSave = column >= 0 && column <= 9 && row >= 0 && row <= 9 ? true : false
        return isAccesToThisIndexSave
    }

    func checkIfFieldIsFree(sea: [[Field]], column: Int, row: Int) -> Bool {
        guard saveAcces(sea: sea, column: column, row: row) else {
            return false
        }
        let fieldIsFree = sea[row][column].getState() == .free &&  checkIfSurroundingFieldsAreFree(sea: sea, column: column, row: row)
        return fieldIsFree
    }

    func checkIfSurroudingFieldIsFree(sea: [[Field]], column: Int,  row: Int) -> Bool {
        var fieldISFree = true
        guard saveAcces(sea: sea, column: column, row: row) else {
            return fieldISFree
        }
        fieldISFree = sea[row][column].getState() == .free
        return fieldISFree
    }

    func checkIfSurroundingFieldsAreFree(sea: [[Field]], column: Int, row: Int) -> Bool {
        var replacingPossibility = checkIfSurroudingFieldIsFree(sea: sea, column: column - 1, row: row - 1) &&
        checkIfSurroudingFieldIsFree(sea: sea, column: column, row: row - 1) &&
        checkIfSurroudingFieldIsFree(sea: sea, column: column + 1, row: row - 1) &&
        checkIfSurroudingFieldIsFree(sea: sea, column: column - 1, row: row) &&
        checkIfSurroudingFieldIsFree(sea: sea, column: column + 1, row: row) &&
        checkIfSurroudingFieldIsFree(sea: sea, column: column - 1, row: row + 1) &&
        checkIfSurroudingFieldIsFree(sea: sea, column: column, row: row + 1) &&
        checkIfSurroudingFieldIsFree(sea: sea, column: column + 1, row: row + 1)
        return replacingPossibility
    }

    func checkVerticalReplacementPossibility(sea: [[Field]], column: Int, row: Int, shipSize: Int) -> Bool {

        var verticalPerplacementPossibility = false
        var sizeCounter = 1
        var column = column
        var row = row
        guard shipSize - 1 <= row else {
            verticalPerplacementPossibility = false
            return verticalPerplacementPossibility
        }

        while sizeCounter <= shipSize {
            verticalPerplacementPossibility = checkIfFieldIsFree(sea: sea, column: column, row: row)
            guard verticalPerplacementPossibility else {
                return verticalPerplacementPossibility
            }
            sizeCounter += 1
            row -= 1
        }

        return verticalPerplacementPossibility
    }

    func checkHorizontalReplacementPossibility(sea: [[Field]], column: Int, row: Int, shipSize: Int) -> Bool {

        var horizontalReplacementPossibility = false
        var sizeCounter = 1
        var column = column
        var row = row

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

    func placeShipVertically(sea: [[Field]], column: Int, row: Int, size: Int, id: Int, player: Player) {

        var temporaryFields: [Field] = []
        var column = column
        var row = row
        var temporaryColumn = column
        var temporaryRow = row
        for _ in 0...size - 1 {
            
            var temporaryField = sea[row][column]
            temporaryFields.append(temporaryField)
            row -= 1
        }
        createShip(player: player, size: size, fields: temporaryFields, id: id)
          }

    func placeShipHorizontally(sea: [[Field]], column: Int, row: Int, size: Int, id: Int, player: Player) {

        var temporaryFields: [Field] = []
        var temporaryColumn = column
        var column = column
        var row = row
        var temporaryRow = row
        for _ in 0...size - 1 {
            
            var temporaryField = sea[row][column]
            temporaryFields.append(temporaryField)
            column += 1
            
        }
        createShip(player: player, size: size, fields: temporaryFields, id: id)
    }

    func createShip(player: Player, size: Int, fields: [Field], id: Int){
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


    func tryReplaceShip(player: Player, field: Int, orientation: orientation, size: Int, id: Int) -> Bool {
        let row = getRow(enter: field)
        let column = getColumn(enter: field)

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
        player.cleaSea()
        var counter = 4
        
        while counter >= 0 {
            replaceAutomatically(player: player, ship: player.getShipAt(index: counter))
            counter -= 1
        }
    }


    func replaceAutomatically(player: Player, ship: Ship) {
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
    

    
    
    
}
