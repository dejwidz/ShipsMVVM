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
    private var possibleNorth: [Field] = []
    private var possibleSouth: [Field] = []
    private var possibleWest: [Field] = []
    private var possibleEast: [Field] = []
    
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
        
        
//        print("player utowrzony, \(self.sea)")
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
    
    func cleaSea() {
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
    
    func setPossibleNorth(newNorth: [Field]) {
        possibleNorth = newNorth
    }
    
    func getPossibleNorth() -> [Field] {
        return possibleNorth
    }
    
    func setPossibleSouth(newSouth: [Field]) {
        possibleSouth = newSouth
    }
    
    func getPossibleSouth() -> [Field] {
        return possibleSouth
    }
    
    func setPossibleWest(newWest: [Field]) {
        possibleWest = newWest
    }
    
    func getPossibleWest() -> [Field] {
        return possibleWest
    }
    
    func setPossibleEast(newEast: [Field]) {
        possibleEast = newEast
    }
    
    func getPossibleEast() -> [Field] {
        return possibleEast
    }
    
    func getEnemySea() -> [[Field]] {
        return enemySea
    }
    
    func addFieldToPossibleNorth(field: Field) {
        possibleNorth.append(field)
    }

}

protocol PlayerDelegate: AnyObject {
    func notifyChangesOfPlayer(_ player: Player)
}
    
extension Player: ShipDelegate {
    func notifyShipChanges(_ ship: Ship) {
        playerDelegate?.notifyChangesOfPlayer(self)
    }
    
    
}
