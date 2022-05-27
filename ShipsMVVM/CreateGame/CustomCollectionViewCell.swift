//
//  CustomCollectionViewCell.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    let identifier = "customCell"
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
            case .hit:
                contentView.backgroundColor = .yellow
            case .hitOccupied:
                contentView.backgroundColor = .red
        }
    }
    
}
