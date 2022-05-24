//
//  PlayerClass.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation

final class Player {
    
    private var name: String
    private var sea: [[Field]]
    
    private var ships: [Ship]
    private var ship2: Ship
    private var ship3: Ship
    private var ship32: Ship
    private var ship4: Ship
    private var ship5: Ship
    
    init(name: String, sea: [[Field]], ship2: Ship, ship3: Ship, ship32: Ship, ship4: Ship, ship5: Ship) {
        self.name = name
        self.sea = sea
        self.ship2 = ship2
        self.ship3 = ship3
        self.ship32 = ship32
        self.ship4 = ship4
        self.ship5 = ship5
        ships = []
        addShips()
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
            ship2.actualizeFields()
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
        print("gracz - aktualizacja morza")
        print(self.sea)
        for i in 0...9 {
            for j in 0...9 {
//                sea[i][j].setState(newState: .free)
                print(sea[i][j].getState())
            }
        }
        for i in ships {
            i.actualizeFields()
//            print( "aktualizacja morza w graczu", i.getFields()[0].getState())
         
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
    

}
    
    
