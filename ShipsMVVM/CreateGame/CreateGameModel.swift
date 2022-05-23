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
}

protocol CreateGameModelDelegate: AnyObject {
    func sendHumanPlayerSea(_ createGameModel: CreateGameModelProtocol, humanPlayerSea: [[Field]])
}

final class CreateGameModel: CreateGameModelProtocol {
    
//    private var humanPlayer: Player
//    private var computerPlayer: Player
    private var humanPlayerSea: [[Field]]
    private var computerPlayerSea: [[Field]]
    weak var createGameModelDelegate: CreateGameModelDelegate?
    
    init() {
        humanPlayerSea = []
//        usunąć tak, żeby nie było warningów
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
        
       

}
    
    func sendHumanPlayerSea() {
        print("MODEL 54",humanPlayerSea[5][4].getState())
        createGameModelDelegate?.sendHumanPlayerSea(self, humanPlayerSea: humanPlayerSea)
    }
}
