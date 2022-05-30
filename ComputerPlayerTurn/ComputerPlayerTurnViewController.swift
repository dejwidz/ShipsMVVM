//
//  ComputerPlayerTurnViewController.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 26/05/2022.
//

import UIKit

class ComputerPlayerTurnViewController: UIViewController {
    private var computerPlayer: Player?
    private var humanPlayer: Player?
    private var viewModel = ComputerPlayerTurnViewModel(model: ComputerPlayerTurnModel())

    @IBOutlet weak var computerPlayerSea: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.computerPlayerTurnViewModelDelegate = self
        viewModel.updateComputerPlayerInModel(computerPlayer: computerPlayer!)
        viewModel.setHumanPlayer(humanPlayer: humanPlayer!)
        

        computerPlayerSea.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "ComputerTurnCustomCollectionViewCell")
        computerPlayerSea.delegate = self
        computerPlayerSea.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        let width: CGFloat = view.frame.width
        let frame = CGRect(x: 25, y: 70, width: width, height: width * 1)
        computerPlayerSea.frame = frame
        computerPlayerSea.collectionViewLayout = layout
        }

    func setComputerPlayer(computerPlayer: Player) {
        self.computerPlayer = computerPlayer
    }
    
    func setHumanPlayer(humanPlayer: Player) {
        self.humanPlayer = humanPlayer
        viewModel.setHumanPlayer(humanPlayer: humanPlayer)
    }

}

extension ComputerPlayerTurnViewController: ComputerPlayerTurnViewModelDelegate {
    func sendComputerPlayer(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol, computerPlayer: Player) {
        self.computerPlayer = computerPlayer
    }
    
    
}

extension ComputerPlayerTurnViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 100
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = computerPlayerSea.dequeueReusableCell(withReuseIdentifier: "ComputerTurnCustomCollectionViewCell",
                                              for: indexPath) as! CustomCollectionViewCell
    cell.contentView.backgroundColor = .red
    
    let row = getRow(enter: indexPath.row)
    let column = getColumn(enter: indexPath.row)
    let temporaryState = (computerPlayer?.getSea()[row][column].getState())!
    cell.actualizeState(newState: temporaryState)
    
    return cell
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.width * 0.08
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        computerPlayer?.getSea()[getRow(enter: indexPath.row)][getColumn(enter: indexPath.row)].setState(newState: .hit)
        computerPlayerSea.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.navigationController?.popViewController(animated: true)
        }
    }

}
