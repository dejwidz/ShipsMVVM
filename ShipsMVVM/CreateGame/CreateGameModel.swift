//
//  CreateGameModel.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation

protocol CreateGameModelProtocol: AnyObject {
    var createGameModelDelegate: CreateGameModelDelegate? {get set}
    func sendHumanPlayerSea()
    func sendHumanPlayer()
    func sendComputerPlayer()
    func actualizePlayer(player: Player)
}

protocol CreateGameModelDelegate: AnyObject {
    func sendHumanPlayerSea(_ createGameModel: CreateGameModelProtocol, humanPlayerSea: [[Field]])
    func sendHumanPlayer(_ createGameModel: CreateGameModelProtocol, humanPlayer: Player)
    func sendComputerPlayer(_ createGameModel: CreateGameModelProtocol, computerPlayer: Player)
}

final class CreateGameModel: CreateGameModelProtocol {
    
    private var humanPlayer: Player
    private var computerPlayer: Player
    private var humanPlayerSea: [[Field]]
    private var computerPlayerSea: [[Field]]
    weak var createGameModelDelegate: CreateGameModelDelegate?
    
    init() {
        humanPlayerSea = []
        for _ in 0...9 {
            var tempArray: [Field] = []
            for _ in 0...9 {
                var x = Field()
                tempArray.append(x)
            }
            humanPlayerSea.append(tempArray)
        }
        
        computerPlayerSea = []
        for _ in 0...9 {
            var tempArray: [Field] = []
            for _ in 0...9 {
                var x = Field()
                tempArray.append(x)
            }
            computerPlayerSea.append(tempArray)
        }
        
        var  humanPlayerEnemySea:[[Field]] = []
        for _ in 0...9 {
            var tempArray: [Field] = []
            for _ in 0...9 {
                var x = Field()
                tempArray.append(x)
            }
            humanPlayerEnemySea.append(tempArray)
        }
        
        var  computerPlayerEnemySea:[[Field]] = []
        for _ in 0...9 {
            var tempArray: [Field] = []
            for _ in 0...9 {
                var x = Field()
                tempArray.append(x)
            }
            computerPlayerEnemySea.append(tempArray)
        }
        
         humanPlayer = Player(name: "humanPlayer", sea: humanPlayerSea, enemySea: humanPlayerEnemySea, ship2: Ship(owner: "humanPlayer", id: 2, size: 2, fields: []), ship3: Ship(owner: "humanPlayer", id: 3, size: 3, fields: []), ship32: Ship(owner: "humanPlayer", id: 32, size: 3, fields: []), ship4: Ship(owner: "humanPlayer", id: 4, size: 4, fields: []), ship5: Ship(owner: "humanPlayer", id: 5, size: 5, fields: []))
        
         computerPlayer = Player(name: "computerPlayer", sea: computerPlayerSea, enemySea: computerPlayerEnemySea, ship2: Ship(owner: "computerPlayer", id: 2, size: 2, fields: []), ship3: Ship(owner: "computerPlayer", id: 3, size: 3, fields: []), ship32: Ship(owner: "computerPlayer", id: 32, size: 3, fields: []), ship4: Ship(owner: "computerPlayer", id: 4, size: 4, fields: []), ship5: Ship(owner: "computerPlayer", id: 5, size: 5, fields: []))
       
        humanPlayer.playerDelegate = self
        computerPlayer.playerDelegate = self
}
    
    func sendHumanPlayerSea() {
        createGameModelDelegate?.sendHumanPlayerSea(self, humanPlayerSea: humanPlayerSea)
    }
    
    func sendHumanPlayer() {
        createGameModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer)
    }
    
    func sendComputerPlayer() {
        createGameModelDelegate?.sendComputerPlayer(self, computerPlayer: computerPlayer)
    }
    
    func actualizePlayer(player: Player) {
        player.actualizeSeaBeforeGame()
    }

    
}

extension CreateGameModel: PlayerDelegate {
    func notifyChangesOfPlayer(_ player: Player) {
        print("playerdelegate w modelu- notify changes")
        createGameModelDelegate?.sendComputerPlayer(self, computerPlayer: computerPlayer)
        createGameModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer)
        createGameModelDelegate?.sendHumanPlayerSea(self, humanPlayerSea: humanPlayerSea)
    }
    
    
}
