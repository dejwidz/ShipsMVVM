//
//  Enums.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation


    
enum fieldState {
    case free
    case occupied
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
    

func getColumn(enter: Int) -> Int {
    let numberOfTheRow = Int(enter/10)
    return numberOfTheRow
}

func getRow(enter: Int) -> Int {
    let numberOfTheColumn: Int = enter % 10
    return numberOfTheColumn
}

infix operator ++

func ++(firstValue: Int, secondValue: Int) -> Int {
    let firstString = "\(firstValue)"
    let secondString = "\(secondValue)"
    let combinedString = firstString + secondString
    let combinedInteger = Int(combinedString)
    return combinedInteger!
}
