//
//  FieldClass.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation

final class Field {
    private var state: fieldState
    
    init() {
        state = .free
    }
    
    func getState() -> fieldState {
        return state
    }
    
    func setState(newState: fieldState) {
        state = newState
    }
    
}
