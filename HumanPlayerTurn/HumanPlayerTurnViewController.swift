//
//  HumanPlayerTurnViewController.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 25/05/2022.
//

import UIKit

class HumanPlayerTurnViewController: UIViewController {
    private var humanPlayer: Player? 
    private var computerPlayer: Player?
    private var humanPlayerEnemySeaMatrix: [[Field]]?
    
    private var viewModel = HumanPlayerTurnViewModel(model: HumanPlayerTurnModel())

    @IBOutlet weak var humanPlayerSeaCollectionView: UICollectionView!
    let vcComputerPlayerTurn = ComputerPlayerTurnViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.humanPlayerTurnViewModelDelegate = self
        viewModel.updateHumanPlayerInModel(humanPlayer: humanPlayer!)
        viewModel.updateComputerPlayerInModel(computerPlayer: computerPlayer!)
        vcComputerPlayerTurn.computerVCDelegate = self

        humanPlayerSeaCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "PlayerTurnCustomCollectionViewCell")
        humanPlayerSeaCollectionView.delegate = self
        humanPlayerSeaCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        let width: CGFloat = view.frame.width
        let frame = CGRect(x: 25, y: 70, width: width, height: width * 1)
        humanPlayerSeaCollectionView.frame = frame
        humanPlayerSeaCollectionView.collectionViewLayout = layout
        
        vcComputerPlayerTurn.setHumanPlayer(humanPlayer: humanPlayer!)
        vcComputerPlayerTurn.setComputerPlayer(computerPlayer: computerPlayer!)
        
        // Do any additional setup after loading the view.
    }

    func setHumanPlayer(humanPlayer: Player) {
        self.humanPlayer = humanPlayer
//        viewModel.updateHumanPlayerInModel(humanPlayer: humanPlayer)
    }
    
    func setComputerPlayer(computerPlayer: Player) {
        self.computerPlayer = computerPlayer
    }
    
    func showAlert(message:String) {
            let alert = UIAlertController(title: "Nice", message: message, preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
        }

    func sendInfoToComputerVCThatShipHasBeenDestroyed() {
        vcComputerPlayerTurn.humanPlayerShipHasBeenDestroyed()
    }

}

extension HumanPlayerTurnViewController: HumanPlayerTurnViewModelDelegate {
    func setTurnIndicatorInComputerPlayerVC(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, currentStateOfTurnIndicator: turn) {
        vcComputerPlayerTurn.setTurnIndicator(currentTurn: currentStateOfTurnIndicator)
    }
    
    func sendHumanPlayerEnemySea(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayerEnemySea: [[Field]]) {
        humanPlayerEnemySeaMatrix = humanPlayerEnemySea
        humanPlayerSeaCollectionView.reloadData()
    }
    
    func sendMessage(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, message: String) {
        showAlert(message: message)
    }
    
    func sendHumanPlayer(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayer: Player) {
        self.humanPlayer = humanPlayer
        
    }
    
    
}

extension HumanPlayerTurnViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 100
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = humanPlayerSeaCollectionView.dequeueReusableCell(withReuseIdentifier: "PlayerTurnCustomCollectionViewCell",
                                              for: indexPath) as! CustomCollectionViewCell
    cell.contentView.backgroundColor = .red
    
    let row = getRow(enter: indexPath.row)
    let column = getColumn(enter: indexPath.row)
    
    let temporaryState = (humanPlayerEnemySeaMatrix![row][column].getState())
    cell.actualizeState(newState: temporaryState)
    
    return cell
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.width * 0.08
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var nextScreenDisplayPossibility = viewModel.humanPlayerShot(index: indexPath.row)
        
        guard nextScreenDisplayPossibility else {return}
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [self] in
            navigationController?.pushViewController(vcComputerPlayerTurn, animated: true)
        }
        
    }
    
}

extension HumanPlayerTurnViewController: ComputerTurnVCSendInfoBackDelegate {
    func sayComputerPlayerHaveMissed(_ computerPlayerTurnViewController: ComputerPlayerTurnViewController) {
        viewModel.computerPlayerHaveMissed()
    }
    
    
}
