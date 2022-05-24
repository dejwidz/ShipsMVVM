//
//  ShipClass.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import Foundation


final class Ship {
    
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
        print("setFields", fields[0].getState())

    }
    
    func getFields() -> [Field] {
        return fields
    }
    
    func actualizeFields() {
        for i in fields {
            i.setState(newState: .occupied)
            print("aktulizacja pol w statku", i.getState())
        }
//        print(fields[0].getState())
        
    }
    
    func getId() -> Int {
        return id
    }
    
    func getSize() -> Int {
        return size
    }
        
    

}


    

