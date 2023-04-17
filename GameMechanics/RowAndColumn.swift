//
//  RowAndColumn.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/04/2023.
//

import Foundation

protocol RowAndColumnSupplier {
    func getColumn(forIndexPathRowValue: Int) -> Int
    func getRow(forIndexPathRowValue: Int) -> Int
}

final class RowAndColumn: RowAndColumnSupplier {
    
    static let shared = RowAndColumn()
    
    private init() {}
    
    func getColumn(forIndexPathRowValue: Int) -> Int {
        return Int(forIndexPathRowValue / 10)
    }

    func getRow(forIndexPathRowValue: Int) -> Int {
        return forIndexPathRowValue % 10
    }
}
