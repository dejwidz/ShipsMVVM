//
//  HumanPlayerTurnViewModel.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 25/05/2022.
//

import Foundation

protocol HumanPlayerTurnViewModelProtocol: AnyObject {
    var humanPlayerTurnViewModelDelegate: HumanPlayerTurnViewModelDelegate? {get set}
    func updateHumanPlayerInModel(humanPlayer: Player)
    func updateComputerPlayerInModel(computerPlayer: Player)
//    func sendHumanPlayer()
    func humanPlayerShot(index: Int) -> Bool
}

protocol HumanPlayerTurnViewModelDelegate: AnyObject {
    func sendHumanPlayer(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayer: Player)
    func sendMessage(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, message: String)
    func sendHumanPlayerEnemySea(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayerEnemySea: [[Field]])
    func setTurnIndicatorInComputerPlayerVC(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, currentStateOfTurnIndicator: turn)
    
}

final class HumanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol {
   
    
    weak var humanPlayerTurnViewModelDelegate: HumanPlayerTurnViewModelDelegate?
//    private var humanPlayer: Player?
//    private var computerPlayer: Player?
    private var model: HumanPlayerTurnModelProtocol
    
    private var humanPlayerEnemySea: [[Field]]?
//    private var humanPlayerShips: [Ship]?
    private var computerPlayerSea: [[Field]]?
    private var computerPlayerShips: [Ship]?
    private var turnIndicator: turn?
    private var hitCounter: Int?
    
    init(model: HumanPlayerTurnModelProtocol) {
        self.model = model
        model.humanPlayerTurnModelDelegate = self
        turnIndicator = .humanPlayerTurn
    }
    
    
    func updateHumanPlayerInModel(humanPlayer: Player) {
//        self.humanPlayer = humanPlayer
        model.updateHumanPlayer(humanPlayer: humanPlayer)
    }
    
    func updateComputerPlayerInModel(computerPlayer: Player) {
//        self.computerPlayer = computerPlayer
        model.updateComputerPlayer(computerPlayer: computerPlayer)    }
    
//    func sendHumanPlayer() {
//        humanPlayerTurnViewModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer!)
//    }
    
    
}

extension HumanPlayerTurnViewModel: HumanPlayerTurnModelDelegate {
    func sendComputerPlayerShips(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, computerPlayerShips: [Ship]) {
        self.computerPlayerShips = computerPlayerShips
    }
    
    func sendComputerPlayerSea(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, computerPlayerSea: [[Field]]) {
        self.computerPlayerSea = computerPlayerSea
    }
    
    func sendHumanPlayerEnemySea(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, humanPlayerEnemySea: [[Field]]) {
        self.humanPlayerEnemySea = humanPlayerEnemySea
        humanPlayerTurnViewModelDelegate?.sendHumanPlayerEnemySea(self, humanPlayerEnemySea: humanPlayerEnemySea)
    }
    
    func sendMessage(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, message: String) {
        humanPlayerTurnViewModelDelegate?.sendMessage(self, message: message)
    }
    
    func sendHumanPlayer(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, humanPlayer: Player) {
//        self.humanPlayer = humanPlayer
        humanPlayerTurnViewModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer)
    }
    
    
}

extension HumanPlayerTurnViewModel {
    func humanPlayerShot(index: Int) -> Bool {
        let row = getRow(enter: index)
        let column = getColumn(enter: index)
        var displayComputerViewController = true
        guard turnIndicator == .humanPlayerTurn else {return true}
        
        if computerPlayerSea![row][column].getState() == .free {
            humanPlayerEnemySea![row][column].setState(newState: .hit)
            model.updateHumanPlayerEnemySea(newEnemySea: humanPlayerEnemySea!)
//            turnIndicator = .computerPlayerTurn
            humanPlayerTurnViewModelDelegate?.setTurnIndicatorInComputerPlayerVC(self, currentStateOfTurnIndicator: turnIndicator!)
            displayComputerViewController = true
        } else {
            computerPlayerSea![row][column].setState(newState: .hitOccupied)
            humanPlayerEnemySea![row][column].setState(newState: .hitOccupied)
            humanPlayerTurnViewModelDelegate?.sendHumanPlayerEnemySea(self, humanPlayerEnemySea: humanPlayerEnemySea!)
            model.updateHumanPlayerEnemySea(newEnemySea: humanPlayerEnemySea!)
            model.updateComputerPlayerSea(newComputerPlayerSea: computerPlayerSea!)
            validateHitCounter()
            checkComputerPlayerShips()
//            turnIndicator = .humanPlayerTurn
            humanPlayerTurnViewModelDelegate?.setTurnIndicatorInComputerPlayerVC(self, currentStateOfTurnIndicator: turnIndicator!)
            displayComputerViewController = false
        }
        return displayComputerViewController
    }
    
    func validateHitCounter() {
        hitCounter = 0
        for i in 0...9 {
            for j in 0...9 {
                if humanPlayerEnemySea![i][j].getState() == .hitOccupied {
                    hitCounter! += 1
                }
            }
        }
        print("___--_____--_____--____-_____--____-_____-_____-_______------_HIT COUNTER \(hitCounter)")
        guard hitCounter! > 16 else {return}
        print("KOKOKOKOKOKOKOKOOKOKOKOKKOKOKOKOKKO")
        humanPlayerTurnViewModelDelegate?.sendMessage(self, message: "You won, the game is Over")
    }
    
    func checkComputerPlayerShips() {
        model.checkComputerPlayerShips()
    }
    
    /* PYTANIE
     
     - Dlaczego sprawdzanie statków nie działa w taki sposób-
     
     func checkComputerPlayerShips() {
     computerPlayerShips.forEach {$0.checkIfTheShipIsStillAlive}
     }
     
     wtedy w ogóle nie widzi w statkach wywołania tej funkcji (sprawdzane printem), choć properka
     computerPlayerShips poprawnie aktualizuje się delegatem z modelu
  
     Wydaje mi się, że wywalenie tego do modelu jest błędne i niezgodne z koncepcją MVVM, ale tam juz działa
     
     */
    
    
}
