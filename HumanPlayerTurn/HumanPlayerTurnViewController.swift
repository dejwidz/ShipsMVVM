//
//  HumanPlayerTurnViewController.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 25/05/2022.
//

import UIKit

class HumanPlayerTurnViewController: UIViewController {
    private var humanPlayer: Player? {
        didSet {
            print("DIDSET PLAYER - HUMANVC")
        }
    }
    private var computerPlayer: Player?
    private var viewModel = HumanPlayerTurnViewModel(model: HumanPlayerTurnModel())

    @IBOutlet weak var humanPlayerSea: UICollectionView!
    let vcComputerPlayerTurn = ComputerPlayerTurnViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.humanPlayerTurnViewModelDelegate = self
        viewModel.updateHumanPlayerInModel(humanPlayer: humanPlayer!)
        viewModel.updateComputerPlayer(computerPlayer: computerPlayer!)

        humanPlayerSea.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "PlayerTurnCustomCollectionViewCell")
        humanPlayerSea.delegate = self
        humanPlayerSea.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        let width: CGFloat = view.frame.width
        let frame = CGRect(x: 25, y: 70, width: width, height: width * 1)
        humanPlayerSea.frame = frame
        humanPlayerSea.collectionViewLayout = layout
        
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


}

extension HumanPlayerTurnViewController: HumanPlayerTurnViewModelDelegate {
    func sendMessage(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, message: String) {
        showAlert(message: message)
    }
    
    func sendHumanPlayer(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayer: Player) {
        print("VC SENDED")
        self.humanPlayer = humanPlayer
        
    }
    
    
}

extension HumanPlayerTurnViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 100
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = humanPlayerSea.dequeueReusableCell(withReuseIdentifier: "PlayerTurnCustomCollectionViewCell",
                                              for: indexPath) as! CustomCollectionViewCell
    cell.contentView.backgroundColor = .red
    
    let row = getRow(enter: indexPath.row)
    let column = getColumn(enter: indexPath.row)
    
    let temporaryState = (humanPlayer?.getSea()[row][column].getState())!
    cell.actualizeState(newState: temporaryState)
    
    return cell
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.width * 0.08
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        vcComputerPlayerTurn.setComputerPlayer(computerPlayer: computerPlayer!)
//        vcComputerPlayerTurn.setHumanPlayer(humanPlayer: humanPlayer!)
//        let nextVC = viewModel.humanPlayerShot(index: indexPath.row)
//
//        guard nextVC else {return}
        
        computerPlayer?.getSea()[getRow(enter: indexPath.row)][getColumn(enter: indexPath.row)].setState(newState: .hitOccupied)
        computerPlayer?.checkShips()
        
        navigationController?.pushViewController(vcComputerPlayerTurn, animated: true)
    }
    
}
