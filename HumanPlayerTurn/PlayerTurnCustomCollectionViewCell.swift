//
//  PlayerTurnCustomCollectionViewCell.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 26/05/2022.
//

import UIKit

class PlayerTurnCustomCollectionViewCell: UICollectionViewCell {
    
    let identifier = "PlayerTurnCustomCollectionViewCell"
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
            contentView.backgroundColor = CustomColors.tealAndGrayBlue
        case .occupied:
            contentView.backgroundColor = CustomColors.occupiedColor
        case .hit:
            contentView.backgroundColor = CustomColors.hitColor
        case .hitOccupied:
            contentView.backgroundColor = CustomColors.hitOccupiedColor
        }
    }
}



