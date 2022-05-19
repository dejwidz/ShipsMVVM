//
//  Enums.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation

//var player1 = Player()

    
enum fieldState {
    case free
    case occupied
    case nearToOccupied
    case hit
    case hitOccupied
    }
    
enum orientation {
    case vertical
    case horizontal
}

enum turn {
    case humanPlayerTurn
    case computerPlayerTurn
}
    
var asd = CreateGameViewController()

func getRow(enter: Int) -> Int {
    let numberOfTheRow = Int(enter/10)
    return numberOfTheRow
}

func getColumn(enter: Int) -> Int {
    let numberOfTheColumn: Int = enter % 10
    return numberOfTheColumn
}


