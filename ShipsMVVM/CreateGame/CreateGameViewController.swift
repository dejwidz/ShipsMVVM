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
        
        viewModel.createGameViewModelDelegate = self
        viewModel.sendHumanSea()
        
        projectSea.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "customCell")
        projectSea.delegate = self
        projectSea.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        let width: CGFloat = view.frame.width
        let frame = CGRect(x: 25, y: 70, width: width, height: width * 1)
        projectSea.frame = frame
        projectSea.collectionViewLayout = layout
    }
    
    
    @IBAction func orientationSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.nextShipOrientation = .vertical
        case 1:
            viewModel.nextShipOrientation = .horizontal
        default:
            print("nothing")
        }
    }
    
    
    @IBAction func chooseShipSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.nextShipId = 2
            viewModel.nextShipSize = 2
        case 1:
            viewModel.nextShipId = 3
            viewModel.nextShipSize = 3
        case 2:
            viewModel.nextShipId = 32
            viewModel.nextShipSize = 3
        case 3:
            viewModel.nextShipId = 4
            viewModel.nextShipSize = 4
        case 4:
            viewModel.nextShipId = 5
            viewModel.nextShipSize = 5
        default:
            print("nothing")
        }
    }
    
    
    @IBAction func generateShipSPositionsButtonTapped(_ sender: Any) {
        viewModel.replaceShipsAutomatically(player: viewModel.humanPlayer!)
    }
    
    
    @IBAction func startGameButtonTapped(_ sender: Any) {
        
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
        
        print("PLANSZA NUMER POLA RANDOM: ", projectSeaMatrix[getColumn(enter: indexPath.row)][getRow(enter: indexPath.row)].randomNumber, "VM ", viewModel.humanPlayer?.getSea()[getColumn(enter: indexPath.row)][getRow(enter: indexPath.row)].randomNumber, "MODEL ")
        
        viewModel.checkDeployingPossibility(index: indexPath.row, shipId: viewModel.nextShipId, shipSize: viewModel.nextShipSize, orientation: viewModel.nextShipOrientation)
        
        
        
//        print("-----------------print komorka ale gracz", viewModel.sea[getColumn(enter: indexPath.row)][getRow(enter: indexPath.row)].getState())
//        projectSeaMatrix[getColumn(enter: indexPath.row)][getRow(enter: indexPath.row)].setState(newState: .hitOccupied)
//        print("-----------------print komorka ale gracz", viewModel.sea[getColumn(enter: indexPath.row)][getRow(enter: indexPath.row)].getState())
//        print(indexPath.row)
//        projectSea.reloadData()
    }
}


extension CreateGameViewController: CreateGameViewModelDelegate {
    func sendHumanPlayerSea(_ createGameViewModel: CreateGameViewModelProtocol, humanPlayerSea: [[Field]]) {
        projectSeaMatrix = humanPlayerSea
        projectSea.reloadData()
        print("VC 54", humanPlayerSea[5][4].getState())
        print("koniec")
    }
    
    
}
