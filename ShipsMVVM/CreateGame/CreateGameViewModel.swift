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
        nextShipId = 0
        nextShipSize = 0
        nextShipOrientation = .vertical
        row = 0
        column = 0
        sea = []
        model.createGameModelDelegate = self
        model.sendHumanPlayer()
        model.sendComputerPlayer()
        
    }
    
    func sendHumanSea() {
        print("VM sendHumanSea")
        model.sendHumanPlayerSea()    }
    
    
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
        print("VM 54", humanPlayerSea[5][4].getState())
        createGameViewModelDelegate?.sendHumanPlayerSea(self, humanPlayerSea: humanPlayerSea)
    }
    
    
}

extension CreateGameViewModel {
    
    func checkDeployingPossibility(index: Int, shipId: Int, shipSize: Int, orientation: orientation) {
        print("checkdeploy pissibility")
        tryReplaceShip(player: humanPlayer!, field: index, orientation: nextShipOrientation, size: nextShipSize, id: nextShipId)
    
    }

    func saveAcces(sea: [[Field]], column: Int, row: Int) -> Bool {
        let isAccesToThisIndexSave = column >= 0 && column <= 9 && row >= 0 && row <= 9 ? true : false
        return isAccesToThisIndexSave
    }

    func checkIfFieldIsFree(sea: [[Field]], column: Int, row: Int) -> Bool {
        guard saveAcces(sea: sea, column: column, row: row) else {
            return false
        }
        let fieldIsFree = sea[column][row].getState() == .free &&  checkIfSurroundingFieldsAreFree(sea: sea, column: column, row: row)
        print("fieldisfree",fieldIsFree, column, row)
        return fieldIsFree
    }

    func checkIfSurroudingFieldIsFree(sea: [[Field]], column: Int,  row: Int) -> Bool {
        print("check & surround")
        var fieldISFree = true
        guard saveAcces(sea: sea, column: column, row: row) else {
            return fieldISFree
        }
        fieldISFree = sea[column][row].getState() == .free
        return fieldISFree
    }

    func checkIfSurroundingFieldsAreFree(sea: [[Field]], column: Int, row: Int) -> Bool {
        print("checkifsurrondingsarefree")
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
        print("checkvertical")

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
            column += 1
        }

        return verticalPerplacementPossibility
    }

    func checkHorizontalReplacementPossibility(sea: [[Field]], column: Int, row: Int, shipSize: Int) -> Bool {
        print("checkhorizontal")

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
            row -= 1
        }

        return horizontalReplacementPossibility
    }

    func placeShipVertically(sea: [[Field]], column: Int, row: Int, size: Int, id: Int, player: Player) {
        print("placevertically")

        var temporaryFields: [Field] = []
        var column = column
        var row = row
        var temporaryColumn = column
        var temporaryRow = row
        for _ in 0...size - 1 {
            
            var temporaryField = sea[column][row]
            temporaryFields.append(temporaryField)
            column += 1
        }
        createShip(player: player, size: size, fields: temporaryFields, id: id)
          }

    func placeShipHorizontally(sea: [[Field]], column: Int, row: Int, size: Int, id: Int, player: Player) {
        print("placehirizontally")

        var temporaryFields: [Field] = []
        var temporaryColumn = column
        var column = column
        var row = row
        var temporaryRow = row
        for _ in 0...size - 1 {
            
            var temporaryField = sea[column][row]
            temporaryFields.append(temporaryField)
            row -= 1
            
            
//            temporaryFields.append(temporaryField)
//            temporaryField = sea[temporaryColumn][temporaryRow - 1]
        }
        createShip(player: player, size: size, fields: temporaryFields, id: id)
    }

    func createShip(player: Player, size: Int, fields: [Field], id: Int){
        print("createship --- fields ", fields)


        switch id {
        case 2:
            player.setShipFields(id: 2, fields: fields)
//            model.actualizePlayer(player: player)
        case 3:
            player.setShipFields(id: 3, fields: fields)
//            model.actualizePlayer(player: player)
        case 32:
            player.setShipFields(id: 32, fields: fields)
//            model.actualizePlayer(player: player)
        case 4:
            player.setShipFields(id: 4, fields: fields)
//            model.actualizePlayer(player: player)
        case 5:
            player.setShipFields(id: 5, fields: fields)
//            model.actualizePlayer(player: player)
        default :
            print("there's no id like that")
        }
        player.actualizeSeaBeforeGame()
    //        delegate?.humanPlayerSeaChanged(self, seaData: model.getHumanPlayerSea())

    }


    func tryReplaceShip(player: Player, field: Int, orientation: orientation, size: Int, id: Int) -> Bool {
        print("tryreplaceship")
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
        
        
//        for i in 0...4 {
//            replaceAutomatically(player: player, ship: player.getShipAt(index: i))
//        }
    }


    func replaceAutomatically(player: Player, ship: Ship) {
        var isPossibleToReplaceShipOnThisField = false
        
        var temporaryCounterdowyjebania = 0

        while !isPossibleToReplaceShipOnThisField {
            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%", temporaryCounterdowyjebania, "   ", ship.getId())
            let field = Int.random(in: 0..<100)
            let orientation: orientation
            let orientationRandomizer = Int.random(in: 0...1)
            if orientationRandomizer == 0 {
                orientation = .vertical
            } else {
                orientation = .horizontal
            }

            isPossibleToReplaceShipOnThisField = tryReplaceShip(player: player, field: field, orientation: orientation, size: ship.getSize(), id: ship.getId())
            temporaryCounterdowyjebania += 1
        }
    }
    

    
    
    
}
