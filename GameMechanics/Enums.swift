//
//  Enums.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation

enum direction {
    case north
    case south
    case west
    case east
    case allDirections
    
    func nextFieldIndex(row: Int, column: Int) -> (row: Int, column: Int) {
        var row = row
        var column = column
        switch self {
        case .north:
            row -= 1
        case .south:
            row += 1
        case .west:
            column -= 1
        case .east:
            column += 1
        case .allDirections:
            print("nothing")
        }
        return (row: row, column: column)
    }
}

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

enum deployPossibility {
    case possible
    case impossible
    case unknown
}

func getColumn(forIndexPathRowValue: Int) -> Int {
    let numberOfTheRow = Int(forIndexPathRowValue/10)
    return numberOfTheRow
}

func getRow(forIndexPathRowValue: Int) -> Int {
    let numberOfTheColumn: Int = forIndexPathRowValue % 10
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


