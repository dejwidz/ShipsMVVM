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
    func humanPlayer(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayer: Player)
    func message(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, message: String)
    func humanPlayerEnemySea(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayerEnemySea: [[Field]])
    func turnIndicatorInComputerPlayerVC(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, currentStateOfTurnIndicator: turn)
    func infoAboutLastShotValidation(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayerLastShot: fieldState)
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
    func computerPlayerShips(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, computerPlayerShips: [Ship]) {
        self.computerPlayerShips = computerPlayerShips
    }
    
    func computerPlayerSea(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, computerPlayerSea: [[Field]]) {
        self.computerPlayerSea = computerPlayerSea
    }
    
    func humanPlayerEnemySea(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, humanPlayerEnemySea: [[Field]]) {
        self.humanPlayerEnemySea = humanPlayerEnemySea
        humanPlayerTurnViewModelDelegate?.humanPlayerEnemySea(self, humanPlayerEnemySea: humanPlayerEnemySea)
    }
    
    func message(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, message: String) {
        humanPlayerTurnViewModelDelegate?.message(self, message: message)
    }
    
    func humanPlayer(_ humanPlayerTurnModel: HumanPlayerTurnModelProtocol, humanPlayer: Player) {
        humanPlayerTurnViewModelDelegate?.humanPlayer(self, humanPlayer: humanPlayer)
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
            humanPlayerTurnViewModelDelegate?.turnIndicatorInComputerPlayerVC(self, currentStateOfTurnIndicator: turnIndicator!)
            humanPlayerTurnViewModelDelegate?.infoAboutLastShotValidation(self, humanPlayerLastShot: .free)
            displayComputerViewController = true
        } else {
            computerPlayerSea![row][column].setState(newState: .hitOccupied)
            humanPlayerEnemySea![row][column].setState(newState: .hitOccupied)
            humanPlayerTurnViewModelDelegate?.humanPlayerEnemySea(self, humanPlayerEnemySea: humanPlayerEnemySea!)
            model.updateHumanPlayerEnemySea(newEnemySea: humanPlayerEnemySea!)
            model.updateComputerPlayerSea(newComputerPlayerSea: computerPlayerSea!)
            validateHitCounter()
            checkComputerPlayerShips()
            turnIndicator = .humanPlayerTurn
            humanPlayerTurnViewModelDelegate?.turnIndicatorInComputerPlayerVC(self, currentStateOfTurnIndicator: turnIndicator!)
            humanPlayerTurnViewModelDelegate?.infoAboutLastShotValidation(self, humanPlayerLastShot: .hitOccupied)
            antiCunningProtector = true
            displayComputerViewController = false
        }
        return displayComputerViewController
    }
    
    private func validateHitCounter() {
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
        humanPlayerTurnViewModelDelegate?.message(self, message: "You won, the game is over")
    }
    
    private func checkComputerPlayerShips() {
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
