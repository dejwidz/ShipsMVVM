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
    let vcHumanPlayerTurn = HumanPlayerTurnViewController()
    private let viewModel = CreateGameViewModel(model: CreateGameModel())
    private var projectSeaMatrix: [[Field]] = []
    private var humanPlayer: Player?
    private var computerPlayer: Player?
    private var deployPossibility: deployPossibility = .unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.createGameViewModelDelegate = self
        viewModel.sendHumanSea()
        viewModel.replaceShipsAutomatically(player: viewModel.computerPlayer!)
        
        
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
        
        guard viewModel.validateStartGamePossibility() else {return}
        vcHumanPlayerTurn.setComputerPlayer(computerPlayer: computerPlayer!)
        vcHumanPlayerTurn.setHumanPlayer(humanPlayer: humanPlayer!)
        navigationController?.pushViewController(vcHumanPlayerTurn, animated: true)
    }
    func showMessage(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
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
        let row = getRow(forIndexPathRowValue: indexPath.row)
        let column = getColumn(forIndexPathRowValue: indexPath.row)
        let temporaryState = (humanPlayer?.getSea()[row][column].getState())!
        cell.actualizeState(newState: temporaryState)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.width * 0.08
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.checkDeployingPossibility(index: indexPath.row, shipId: viewModel.nextShipId, shipSize: viewModel.nextShipSize, orientation: viewModel.nextShipOrientation)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        viewModel.checkDeployingPossibilityWithoutDeploying(fieldIndex: indexPath.row)
        let cell = projectSea.cellForItem(at: indexPath)
        if deployPossibility == .possible {
            cell?.contentView.backgroundColor = UIColor.green
        }
        else {
            cell?.contentView.backgroundColor = UIColor.orange
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = projectSea.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = .systemTeal
        deployPossibility = .unknown
        projectSea.reloadData()
    }
    
}


extension CreateGameViewController: CreateGameViewModelDelegate {
    func sendInfoAboutDeployingPossibility(_ createGameViewModel: CreateGameViewModelProtocol, info: deployPossibility) {
        deployPossibility = info
    }
    
    func sendMessage(_ createGameViewModel: CreateGameViewModelProtocol, owner: String, message: String) {
        if owner == "computerPlayer" {
            vcHumanPlayerTurn.showAlert(message: message)
        }
        else if owner == "humanPlayer" {
            vcHumanPlayerTurn.sendInfoToComputerVCThatShipHasBeenDestroyed()
        }
    }
    
    func sendComputerPlayer(_ createGameViewModel: CreateGameViewModelProtocol, computerPlayer: Player) {
        self.computerPlayer = computerPlayer
    }
    
    func sayNoYouCantDoingLikeThat(_ createGameViewModel: CreateGameViewModelProtocol, message: String) {
        showMessage(message: message)
    }
    
    func sendHumanPlayerSea(_ createGameViewModel: CreateGameViewModelProtocol, humanPlayerSea: [[Field]], humanPlayer: Player) {
        projectSeaMatrix = humanPlayerSea
        projectSea.reloadData()
        self.humanPlayer = humanPlayer
    }
    
    
}
