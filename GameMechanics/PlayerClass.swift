//
//  PlayerClass.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation

final class Player {
    
    weak var playerDelegate: PlayerDelegate?
    
    private var name: String
    private var sea: [[Field]] {
        didSet {
            playerDelegate?.notifyChangesOfPlayer(self)
        }
    }
    private var enemySea: [[Field]]
    
    private var ships: [Ship]
    private var ship2: Ship
    private var ship3: Ship
    private var ship32: Ship
    private var ship4: Ship
    private var ship5: Ship
    
    private var firstHitIndicator = false
    private var hitIndicator = false
    private var possibleNorth: [Int] = []
    private var possibleSouth: [Int] = []
    private var possibleWest: [Int] = []
    private var possibleEast: [Int] = []
    
    
    init(name: String, sea: [[Field]], enemySea: [[Field]], ship2: Ship, ship3: Ship, ship32: Ship, ship4: Ship, ship5: Ship) {
        self.name = name
        self.sea = sea
        self.enemySea = enemySea
        self.ship2 = ship2
        self.ship3 = ship3
        self.ship32 = ship32
        self.ship4 = ship4
        self.ship5 = ship5
        ships = []
        addShips()

        ship2.shipDelegate = self
        ship3.shipDelegate = self
        ship32.shipDelegate = self
        ship4.shipDelegate = self
        ship5.shipDelegate = self
        }
    
    func addShips() {
        ships.append(ship2)
        ships.append(ship3)
        ships.append(ship32)
        ships.append(ship4)
        ships.append(ship5)
    }
    
    
    func setShipFields(id: Int, fields: [Field]) {
        switch id {
        case 2:
            ship2.setFields(fields: fields)
        case 3:
            ship3.setFields(fields: fields)
        case 32:
            ship32.setFields(fields: fields)
        case 4:
            ship4.setFields(fields: fields)
        case 5:
            ship5.setFields(fields: fields)
        default:
            print("nothing")
        }
    }
    
    func actualizeSeaBeforeGame() {
        for i in 0...9 {
            for j in 0...9 {
                sea[i][j].setState(newState: .free)
            }
        }
        for i in ships {
            i.actualizeFields()
        }
    }
    
    func getSea() -> [[Field]] {
        return sea
    }
    
    func getShipAt(index: Int) -> Ship {
    return ships[index]
}
    
    func setSea(newSea: [[Field]]) {
        sea = newSea
    }
    
    func clearSea() {
        for i in 0...9 {
            for j in 0...9 {
                self.sea[i][j].setState(newState: .free)
            }
        }
        for i in ships {
            i.clearFields()
        }
    }
    
    func setFirstHitIndicator(newValueOfFirstHitIndicator: Bool){
        firstHitIndicator = newValueOfFirstHitIndicator
    }
    
    func getFirstHitIndicator() -> Bool {
        return firstHitIndicator
    }
    
    func setHitIndicator(newValueOfHitIndicator: Bool) {
        hitIndicator = newValueOfHitIndicator
    }
    
    func getHitIndicator() -> Bool {
        return hitIndicator
    }
    
    func getPossibleNorth() -> [Int] {
        return possibleNorth
    }
    
    func getPossibleSouth() -> [Int] {
        return possibleSouth
    }
    
    func getPossibleWest() -> [Int] {
        return possibleWest
    }
    
    func getPossibleEast() -> [Int] {
        return possibleEast
    }
    
    func getEnemySea() -> [[Field]] {
        return enemySea
    }
    
    func setEnemySea(newEnemySea: [[Field]]) {
        enemySea = newEnemySea
    }
    
    func setPossibleNorth(possibleNorth: [Int]) {
        self.possibleNorth = possibleNorth
    }
    
    func setPossibleSouth(possibleSouth: [Int]) {
        self.possibleSouth = possibleSouth
        
    }
    
    func setPossibleWest(possibleWest: [Int]) {
        self.possibleWest = possibleWest
        
    }
    
    func setPossibleEast(possibleEast: [Int]) {
        self.possibleEast = possibleEast
        
    }
    
//    func removeLastFieldFromNorth() {
//        possibleNorth.remove(at: 0)
//    }
//
//    func removeLastFieldFromSouth() {
//        possibleSouth.remove(at: 0)
//    }
//    
//    func removeLastFieldFromWest() {
//        possibleWest.remove(at: 0)
//    }
//
//    func removeLastFieldFromEast() {
//        possibleEast.remove(at: 0)
//    }
    
    
    
    func clearNorth() {
        possibleNorth = []
    }
    
    func clearSouth() {
        possibleSouth = []
    }
    
    func clearWest() {
        possibleWest = []
    }
    
    func clearEast() {
        possibleEast = []
    }
    
    
    func checkShips() {
        ships.forEach {$0.checkIfTheShipisStillAlive()}
    }
    
    func setShips(newShips: [Ship]) {
        ships = newShips
    }
    
    func getShips() -> [Ship] {
        return ships
    }

}

protocol PlayerDelegate: AnyObject {
    func notifyChangesOfPlayer(_ player: Player)
    func sendMessage(_ player: Player, owner: String, message: String)
}

extension Player: ShipDelegate {
    func sayIHaveBeenDestroyed(_ ship: Ship, owner: String, message: String) {
        playerDelegate?.sendMessage(self, owner: owner, message: message)
        hitIndicator = false
        firstHitIndicator = false
        playerDelegate?.notifyChangesOfPlayer(self)
    }
    
    func notifyShipChanges(_ ship: Ship) {
        playerDelegate?.notifyChangesOfPlayer(self)
    }
    
    
}
