//
//  ShipClass.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation


final class Ship {
    
    weak var shipDelegate: ShipDelegate?
    
    private let owner: String
    private let id: Int
    private let size: Int
    private var fields: [Field]
    private var isLive: Bool
    
    init(owner: String,id: Int, size: Int, fields: [Field]) {
        self.owner = owner
        self.id = id
        self.size = size
        self.fields = fields
        isLive = true
    }
    
    func checkIfTheShipisStillAlive() -> Bool {
        var shipIsStillAlive = false
        for i in fields {
            if i.getState() == .occupied {
                shipIsStillAlive = true
                break
            }
        }
        return shipIsStillAlive
    }
    
    func setFields(fields: [Field]) {
        self.fields = fields
        actualizeFields()
        shipDelegate?.notifyShipChanges(self)
    }
    
    func getFields() -> [Field] {
        return fields
    }
    
    func actualizeFields() {
    
        for i in fields {
            i.setState(newState: .occupied)
        }
    }
    
    func getId() -> Int {
        return id
    }
    
    func getSize() -> Int {
        return size
    }
    
    func clearFields() {
        fields = []
    }
        
    

}


protocol ShipDelegate: AnyObject {
    func notifyShipChanges(_ ship: Ship)
}

