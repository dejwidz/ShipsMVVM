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
//    var humanPlayer: Player
//    var computerPlayer: Player
    
    init(model: CreateGameModelProtocol){
        self.model = model
        nextShipId = 2
        nextShipSize = 2
        nextShipOrientation = .vertical
        row = 0
        column = 0
        sea = []
        model.createGameModelDelegate = self
        
        
    }
    
    func sendHumanSea() {
        print("VM sendHumanSea")
        model.sendHumanPlayerSea()    }
    
    
}

extension CreateGameViewModel: CreateGameModelDelegate {
    func sendHumanPlayerSea(_ createGameModel: CreateGameModelProtocol, humanPlayerSea: [[Field]]) {
        sea = humanPlayerSea
        print("VM 54", humanPlayerSea[5][4].getState())
        createGameViewModelDelegate?.sendHumanPlayerSea(self, humanPlayerSea: humanPlayerSea)
    }
    
    
}

