//
//  CreateGameModel.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation

protocol CreateGameModelProtocol {
    func actualizePlayerSea(player: Player, sea: [[Field]])
    func sendFirstHumanPlayerSea()
    func getHumanPlayer() -> Player
    func getComputerPlayer() -> Player
}

protocol CreateGameModelDelegate: AnyObject {
    func humanPlayerSeaHasBeenActualized(_ createGameModel: CreateGameModel, sea: [[Field]])
    func sendSeaBeforeGame(_ createGameModel: CreateGameModel, sea: [[Field]])
}

final class CreateGameModel {
    
    private var humanPlayer: Player
    private var computerPlayer: Player
    weak var delegate: CreateGameModelDelegate?
    private var humanPlayerSea: [[Field]]
    private var computerPlayerSea: [[Field]]

    init() {
        
        humanPlayerSea = []
        for i in 0...9 {
        var tempArray: [Field] = []
        for i in 0...9 {
            var x = Field()
            tempArray.append(x)
        }
            humanPlayerSea.append(tempArray)
        }
        
        computerPlayerSea = []
        for i in 0...9 {
        var tempArray: [Field] = []
        for i in 0...9 {
            var x = Field()
            tempArray.append(x)
        }
            computerPlayerSea.append(tempArray)
        }
        
        var humanPlayerShip2 = Ship(id: 2, size: 2, fields: [])
        var humanPlayerShip3 = Ship(id: 3, size: 3, fields: [])
        var humanPlayerShip32 = Ship(id: 32, size: 3, fields: [])
        var humanPlayerShip4 = Ship(id: 4, size: 4, fields: [])
        var humanPlayerShip5 = Ship(id: 5, size: 5, fields: [])
        humanPlayer = Player(sea: humanPlayerSea, ship2: humanPlayerShip2, ship3: humanPlayerShip3, ship32: humanPlayerShip32, ship4: humanPlayerShip4, ship5: humanPlayerShip5)
        
        var computerPlayerShip2 = Ship(id: 2, size: 2, fields: [])
        var computerPlayerShip3 = Ship(id: 3, size: 3, fields: [])
        var computerPlayerShip32 = Ship(id: 32, size: 3, fields: [])
        var computerPlayerShip4 = Ship(id: 4, size: 4, fields: [])
        var computerPlayerShip5 = Ship(id: 5, size: 5, fields: [])
        computerPlayer = Player(sea: computerPlayerSea, ship2: computerPlayerShip2, ship3: computerPlayerShip3, ship32: computerPlayerShip32, ship4: computerPlayerShip4, ship5: computerPlayerShip5)
        delegate?.sendSeaBeforeGame(self, sea: humanPlayerSea)
    }
    
    
}

extension CreateGameModel: CreateGameModelProtocol {
    func sendFirstHumanPlayerSea() {
        delegate?.sendSeaBeforeGame(self, sea: humanPlayerSea)
    }
    
    
    func actualizePlayerSea(player: Player, sea: [[Field]]) {
        player.setSea(newSea: sea)
        delegate?.humanPlayerSeaHasBeenActualized(self, sea: humanPlayer.getSea())
    }
    
    
    func getHumanPlayer() -> Player {
        return humanPlayer
    }
    
    func getComputerPlayer() -> Player {
        return computerPlayer
    }
    
    func getHumanPlayerSea() -> [[Field]] {
        return computerPlayer.getSea()
    }
    
    
    func getComputerPlayerSea() -> [[Field]] {
        return computerPlayer.getSea()
    }
    
    
    
}

    
    

