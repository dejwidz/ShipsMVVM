//
//  PlayerClass.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation

protocol PlayerDelegate: AnyObject {
    func notifyChangesOfPlayer(_ player: Player)
    func sendMessage(_ player: Player, owner: String, message: String)
}

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
    
    private var hitIndicator = false
    private var possibleNorth: [Int] = []
    private var possibleSouth: [Int] = []
    private var possibleWest: [Int] = []
    private var possibleEast: [Int] = []
    
    private var northIndicator: Bool
    private var southIndicator: Bool
    private var westIndicator: Bool
    private var eastIndicator: Bool
    
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
        
        northIndicator = false
        southIndicator = false
        westIndicator = false
        eastIndicator = false
        
        ship2.shipDelegate = self
        ship3.shipDelegate = self
        ship32.shipDelegate = self
        ship4.shipDelegate = self
        ship5.shipDelegate = self
        addShips()
    }
    
    private func addShips() {
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
    
    func getShipAt(index: Int) -> Ship {
        return ships[index]
    }
    
    func actualizeSeaBeforeGame() {
        for row in 0...9 {
            for column in 0...9 {
                sea[row][column].setState(newState: .free)
            }
        }
        for ship in ships {
            ship.actualizeFields()
        }
    }
    
    func getSea() -> [[Field]] {
        return sea
    }
    
    func setSea(newSea: [[Field]]) {
        sea = newSea
    }
    
    func clearSea() {
        for row in 0...9 {
            for column in 0...9 {
                self.sea[row][column].setState(newState: .free)
            }
        }
        for ship in ships {
            ship.clearFields()
        }
    }
    
    func setHitIndicator(newValueOfHitIndicator: Bool) {
        hitIndicator = newValueOfHitIndicator
    }
    
    func getHitIndicator() -> Bool {
        return hitIndicator
    }
    
    func getPossibleDirection(direction: direction) -> [Int] {
        switch direction {
        case .north:
            return possibleNorth
        case .south:
            return possibleSouth
        case .west:
            return possibleWest
        case .east:
            return possibleEast
        case .allDirections:
            return []
        }
    }
    
    func getEnemySea() -> [[Field]] {
        return enemySea
    }
    
    func setEnemySea(newEnemySea: [[Field]]) {
        enemySea = newEnemySea
    }
    
    func setPossibleDirection(direction: direction, possibleFields: [Int]) {
        switch direction {
        case .north:
            possibleNorth = possibleFields
        case .south:
            possibleSouth = possibleFields
        case .west:
            possibleWest = possibleFields
        case .east:
            possibleEast = possibleFields
        case .allDirections:
            print("nothing")
        }
    }
    
    func clearDirection(direction: direction) {
        switch direction {
        case .north:
            possibleNorth = []
        case .south:
            possibleSouth = []
        case .west:
            possibleWest = []
        case .east:
            possibleEast = []
        case .allDirections:
            possibleNorth = []
            possibleSouth = []
            possibleWest = []
            possibleEast = []
        }
    }
    
    func setShips(newShips: [Ship]) {
        ships = newShips
    }
    
    func getShips() -> [Ship] {
        return ships
    }
    
    func setIndicator(direction: direction, newIndicatorValue: Bool) {
        switch direction {
        case .north:
            northIndicator = newIndicatorValue
        case .south:
            southIndicator = newIndicatorValue
        case .west:
            westIndicator = newIndicatorValue
        case .east:
            eastIndicator = newIndicatorValue
        case .allDirections:
            print("nothing")
        }
    }
    
    func getIndicator(direction: direction) -> Bool {
        switch direction {
        case .north:
            return northIndicator
        case .south:
            return southIndicator
        case .west:
            return westIndicator
        case .east:
            return eastIndicator
        case .allDirections:
            return false
        }
    }
}

extension Player: ShipDelegate {
    func shipHasBeenDestroyed(_ ship: Ship, owner: String, message: String) {
        playerDelegate?.sendMessage(self, owner: owner, message: message)
        playerDelegate?.notifyChangesOfPlayer(self)
    }
    
    func notifyShipChanges(_ ship: Ship) {
        playerDelegate?.notifyChangesOfPlayer(self)
    }
}
