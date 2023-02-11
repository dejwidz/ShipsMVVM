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
    func humanPlayerShot(index: Int) -> Bool
    func setAntiCunningProtector(newValueOfProtector: Bool)
    func computerPlayerMissed()
}

protocol HumanPlayerTurnViewModelDelegate: AnyObject {
    func sendHumanPlayer(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayer: Player)
    func sendMessage(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, message: String)
    func sendHumanPlayerEnemySea(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayerEnemySea: [[Field]])
    func setTurnIndicatorInComputerPlayerVC(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, currentStateOfTurnIndicator: turn)
    func sendInfoAboutLastShotValidation(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayerLastShot: fieldState)
}

final class HumanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol {
   
    weak var humanPlayerTurnViewModelDelegate: HumanPlayerTurnViewModelDelegate?
    private var model: HumanPlayerTurnModelProtocol
    private var humanPlayerEnemySea: [[Field]]?
    private var computerPlayerSea: [[Field]]?
    private var computerPlayerShips: [Ship]?
    private var turnIndicator: turn?
    private var hitCounter: Int?
    private var antiCunningProtector: Bool?
    private var gameOverIndicator: Bool
    
    init(model: HumanPlayerTurnModelProtocol) {
        self.model = model
        turnIndicator = .humanPlayerTurn
        antiCunningProtector = true
        gameOverIndicator = true
        model.humanPlayerTurnModelDelegate = self
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
    
    func computerPlayerMissed() {
        antiCunningProtector = true
        turnIndicator = .humanPlayerTurn
    }
    
}

extension HumanPlayerTurnViewModel {
    func humanPlayerShot(index: Int) -> Bool {
        guard antiCunningProtector! && gameOverIndicator else {return false}
        
        antiCunningProtector = false
        let row = getRow(forIndexPathRowValue: index)
        let column = getColumn(forIndexPathRowValue: index)
        var displayComputerViewController = true
        guard turnIndicator == .humanPlayerTurn else {return true}
        
        if computerPlayerSea![row][column].getState() == .free {
            humanPlayerEnemySea![row][column].setState(newState: .hit)
            model.updateHumanPlayerEnemySea(newEnemySea: humanPlayerEnemySea!)
            turnIndicator = .computerPlayerTurn
            humanPlayerTurnViewModelDelegate?.setTurnIndicatorInComputerPlayerVC(self, currentStateOfTurnIndicator: turnIndicator!)
            humanPlayerTurnViewModelDelegate?.sendInfoAboutLastShotValidation(self, humanPlayerLastShot: .free)
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
            humanPlayerTurnViewModelDelegate?.sendInfoAboutLastShotValidation(self, humanPlayerLastShot: .hitOccupied)
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
        gameOverIndicator = false
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
