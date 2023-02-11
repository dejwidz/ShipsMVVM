//
//  ComputerPlayerTurnViewController.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 26/05/2022.
//

import UIKit

protocol ComputerTurnVCSendInfoBackDelegate: AnyObject {
    func sayComputerPlayerMissed(_ computerPlayerTurnViewController: ComputerPlayerTurnViewController)
}

class ComputerPlayerTurnViewController: UIViewController {
    private var computerPlayer: Player?
    private var humanPlayer: Player?
    private var viewModel = ComputerPlayerTurnViewModel(model: ComputerPlayerTurnModel())
    private var computerPlayerEnemySeaMatrix: [[Field]]?
    weak var computerVCDelegate: ComputerTurnVCSendInfoBackDelegate?
    @IBOutlet weak var computerPlayerSeaCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.computerPlayerTurnViewModelDelegate = self
        viewModel.setComputerPlayer(computerPlayer: computerPlayer!)
        viewModel.setHumanPlayer(humanPlayer: humanPlayer!)
        
        computerPlayerSeaCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "ComputerTurnCustomCollectionViewCell")
        computerPlayerSeaCollectionView.delegate = self
        computerPlayerSeaCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat = UIScreen.main.bounds.width
        layout.minimumLineSpacing = width * 0.00935
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = width * 0.00935
        let frame = CGRect(x: 0, y: 100, width: width, height: width )
        computerPlayerSeaCollectionView.frame = frame
        computerPlayerSeaCollectionView.collectionViewLayout = layout
        }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.computerPlayerShot()
    }

    func setComputerPlayer(computerPlayer: Player) {
        self.computerPlayer = computerPlayer
        viewModel.setComputerPlayer(computerPlayer: computerPlayer)
    }
    
    func setHumanPlayer(humanPlayer: Player) {
        self.humanPlayer = humanPlayer
        viewModel.setHumanPlayer(humanPlayer: humanPlayer)
    }
    
    func setTurnIndicator(currentTurn: turn) {
        viewModel.setTurnIndicator(currentTurn: currentTurn)
    }
    
    func humanPlayerShipHasBeenDestroyed() {
        viewModel.resetEverythingWhenHumanPlayerShipHaveBeenDestroyed()
    }
    
    func showAlert(message:String) {
            let alert = UIAlertController(title: "Try again", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
        }

}

extension ComputerPlayerTurnViewController: ComputerPlayerTurnViewModelDelegate {
    func sendInfoForAnimation(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol, indexOfNextFieldToShot: Int, stateOfNextFieldToShot: fieldState) {
        let index = NSIndexPath(row: indexOfNextFieldToShot, section: 0)
        let cell = computerPlayerSeaCollectionView.cellForItem(at: index as IndexPath)
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.fromValue = cell?.contentView.backgroundColor?.cgColor
        if stateOfNextFieldToShot == .free {
            animation.toValue = UIColor.yellow.cgColor
        }
        else if stateOfNextFieldToShot == .hitOccupied {
            animation.toValue = UIColor.red.cgColor
        }
        animation.duration = 0.8
        cell?.contentView.layer.add(animation, forKey: nil)
    }
    
    func sayComputerPlayerWon(_ computerPlayerTurnModel: ComputerPlayerTurnViewModelProtocol, message: String) {
        showAlert(message: message)
    }
    
    func sayIHaveMissed(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol) {
        computerVCDelegate?.sayComputerPlayerMissed(self)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func sendComputerPlayerEnemySea(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol, computerPlayerEnemySea: [[Field]]) {
        computerPlayerEnemySeaMatrix = computerPlayerEnemySea
        computerPlayerSeaCollectionView.reloadData()
    }
}

extension ComputerPlayerTurnViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 100
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = computerPlayerSeaCollectionView.dequeueReusableCell(withReuseIdentifier: "ComputerTurnCustomCollectionViewCell",
                                              for: indexPath) as! CustomCollectionViewCell
    let row = getRow(forIndexPathRowValue: indexPath.row)
    let column = getColumn(forIndexPathRowValue: indexPath.row)
    let temporaryState = computerPlayerEnemySeaMatrix![row][column].getState()
    cell.actualizeState(newState: temporaryState)
    
    return cell
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.width * 0.091
        return CGSize(width: size, height: size)
    }

}
