//
//  CreateGameViewController.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import UIKit

final class CreateGameViewController: UIViewController {
    
    @IBOutlet private weak var projectSea: UICollectionView!
    @IBOutlet private weak var orientationSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var chooseShipSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var generateShipPositionsButton: UIButton!
    @IBOutlet private weak var startGameButton: UIButton!
    private let viewModel = CreateGameViewModel(model: CreateGameModel())
    private var projectSeaMatrix: [[Field]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getFirstSea()
//        projectSeaMatrix[5][4].setState(newState: .hit)
        viewModel.delegate = self
        projectSea.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "customCell")
        projectSea.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        let width: CGFloat = view.frame.width
        let frame = CGRect(x: 25, y: 70, width: width, height: width * 1)
        projectSea.frame = frame
        projectSea.collectionViewLayout = layout
    }
}

extension CreateGameViewController: UICollectionViewDelegateFlowLayout,
                                        UICollectionViewDelegate,
                                        UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = projectSea.dequeueReusableCell(withReuseIdentifier: "customCell",
                                                  for: indexPath) as! CustomCollectionViewCell
        cell.contentView.backgroundColor = .red
        
        let row = getRow(enter: indexPath.row)
        let column = getColumn(enter: indexPath.row)
        
        let temporaryState = projectSeaMatrix[column][row].getState()
        cell.actualizeState(newState: temporaryState)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.width * 0.08
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.checkDeployingPossibility(index: indexPath.row,
//                                           //Po co przekazywać te dane z viewModelu do viewModelu, skoro one tam już są?
                                            shipId: viewModel.nextShipId,
                                            shipSize: viewModel.nextShipSize,
                                            orientation: viewModel.nextShipOrientation)
        print("-----------------print komorka ale gracz", viewModel.sea[getColumn(enter: indexPath.row)][getRow(enter: indexPath.row)].getState())
    }
}

extension CreateGameViewController: CreateGameViewModelDelegate {
    func actualizedHumanPlayerSeaHaveBeenSended(_ createGameViewModel: CreateGameViewModel, humanPlayerSea: [[Field]]) {
        projectSeaMatrix = humanPlayerSea
        projectSea.dataSource = self
        projectSea.reloadData()
    }
}
