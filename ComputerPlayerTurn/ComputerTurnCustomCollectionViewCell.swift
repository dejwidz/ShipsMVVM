//
//  ComputerTurnCustomCollectionViewCell.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 26/05/2022.
//

import UIKit

class ComputerTurnCustomCollectionViewCell: UICollectionViewCell {
    
    let identifier = "ComputerTurnCustomCollectionViewCell"
    var state: fieldState = .free
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func actualizeState(newState: fieldState) {
        state = newState
        switch state {
            case .free:
                contentView.backgroundColor = .systemTeal
            case .occupied:
                contentView.backgroundColor = .systemGray
            case .nearToOccupied:
                contentView.backgroundColor = .orange
            case .hit:
                contentView.backgroundColor = .yellow
            case .hitOccupied:
                contentView.backgroundColor = .red
        }
    }
    

}



