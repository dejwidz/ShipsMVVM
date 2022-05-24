//
//  FieldClass.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation

final class Field {
    private var state: fieldState
    var randomNumber: Int
    
    init(random: Int) {
        state = .free
        randomNumber = random
    }
    
    func getState() -> fieldState {
        return state
    }
    
    func setState(newState: fieldState) {
        state = newState
    }
    
}
