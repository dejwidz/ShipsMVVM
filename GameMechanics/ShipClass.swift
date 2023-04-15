//
//  ShipClass.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation

protocol ShipDelegate: AnyObject {
    func notifyShipChanges(_ ship: Ship)
    func shipHasBennDestroyed(_ ship: Ship, owner: String, message: String)
}

final class Ship {
    
    weak var shipDelegate: ShipDelegate?
    
    private let owner: String
    private let id: Int
    private let size: Int
    private var fields: [Field]
    private var isLive: Bool {
        didSet {
            guard oldValue != isLive else {return}
            shipDelegate?.shipHasBennDestroyed(self, owner: owner, message: "Ship of size \(size) has been destroyed")
        }
    }
    
    init(owner: String,id: Int, size: Int, fields: [Field]) {
        self.owner = owner
        self.id = id
        self.size = size
        self.fields = fields
        isLive = true
    }
    
    @discardableResult func checkIfTheShipIsStillAlive() -> Bool {
        var shipIsStillAlive = false
        for field in fields {
            if field.getState() == .occupied {
                shipIsStillAlive = true
                break
            }
        }
        isLive = shipIsStillAlive
        return shipIsStillAlive
    }
    
    func setFields(fields: [Field]) {
        self.fields = fields
        actualizeFields()
        shipDelegate?.notifyShipChanges(self)
    }
    
    func actualizeFields() {
        for field in fields {
            field.setState(newState: .occupied)
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
