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
    func setAntiCunningProtector(newValueOfProtector: Bool)
    func computerPlayerHaveMissed()
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
    private var antiCunningProtector: Bool?
    
    init(model: HumanPlayerTurnModelProtocol) {
        self.model = model
        model.humanPlayerTurnModelDelegate = self
        turnIndicator = .humanPlayerTurn
        antiCunningProtector = true
    }
    
    
    func updateHumanPlayerInModel(humanPlayer: Player) {
        model.updateHumanPlayer(humanPlayer: humanPlayer)
    }
    
    func updateComputerPlayerInModel(computerPlayer: Player) {
        model.updateComputerPlayer(computerPlayer: computerPlayer)
    }
    
    func setAntiCunningProtector(newValueOfProtector: Bool) {
        antiCunningProtector = newValueOfProtector
    }
    
    
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
        humanPlayerTurnViewModelDelegate?.sendHumanPlayer(self, humanPlayer: humanPlayer)
    }
    
    func computerPlayerHaveMissed() {
        antiCunningProtector = true
        turnIndicator = .humanPlayerTurn
    }
    
    
}

extension HumanPlayerTurnViewModel {
    func humanPlayerShot(index: Int) -> Bool {
        guard antiCunningProtector! else {return false}
        
        antiCunningProtector = false
        let row = getRow(enter: index)
        let column = getColumn(enter: index)
        var displayComputerViewController = true
        guard turnIndicator == .humanPlayerTurn else {return true}
        
        if computerPlayerSea![row][column].getState() == .free {
            humanPlayerEnemySea![row][column].setState(newState: .hit)
            model.updateHumanPlayerEnemySea(newEnemySea: humanPlayerEnemySea!)
            turnIndicator = .computerPlayerTurn
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
            turnIndicator = .humanPlayerTurn
            humanPlayerTurnViewModelDelegate?.setTurnIndicatorInComputerPlayerVC(self, currentStateOfTurnIndicator: turnIndicator!)
            antiCunningProtector = true
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
        guard hitCounter! > 16 else {return}
        humanPlayerTurnViewModelDelegate?.sendMessage(self, message: "You won, the game is over")
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
     computerPlayerShips poprawnie aktualizuje się delegatem z modelu (sprawdzane printem)
  
     Wydaje mi się, że wywalenie tego do modelu jest błędne i niezgodne z koncepcją MVVM, ale tam juz działa
     
     */
    
    
}
