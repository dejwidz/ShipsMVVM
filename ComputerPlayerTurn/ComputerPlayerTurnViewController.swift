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
    private var computerPlayerSeaCollectionView: UICollectionView!
    private var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.computerPlayerTurnViewModelDelegate = self
        viewModel.setComputerPlayer(computerPlayer: computerPlayer!)
        viewModel.setHumanPlayer(humanPlayer: humanPlayer!)
        setupInterface()
        computerPlayerSeaCollectionView.delegate = self
        computerPlayerSeaCollectionView.dataSource = self
    }
    
    private func setupInterface() {
        let w = UIScreen.main.bounds.width
        view.backgroundColor = CustomColors.backColor
        
        mainScrollView = UIScrollView()
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.contentInsetAdjustmentBehavior = .always
        mainScrollView.backgroundColor = CustomColors.backColor
        mainScrollView.contentSize = CGSize(width: w, height: w)
        mainScrollView.isDirectionalLockEnabled = true
        
        computerPlayerSeaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        computerPlayerSeaCollectionView.register(ComputerTurnCustomCollectionViewCell.self, forCellWithReuseIdentifier: "ComputerTurnCustomCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: w * 0.091, height: w * 0.093)
        layout.minimumLineSpacing = w * 0.009
        layout.minimumInteritemSpacing = w * 0.005
        layout.scrollDirection = .horizontal
        computerPlayerSeaCollectionView.collectionViewLayout = layout
        computerPlayerSeaCollectionView.translatesAutoresizingMaskIntoConstraints = false
        computerPlayerSeaCollectionView.backgroundColor = CustomColors.backColor
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(computerPlayerSeaCollectionView)
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            computerPlayerSeaCollectionView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            computerPlayerSeaCollectionView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            computerPlayerSeaCollectionView.widthAnchor.constraint(equalToConstant: w),
            computerPlayerSeaCollectionView.heightAnchor.constraint(equalToConstant: w),
        ])
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
    
    private func showAlert(message:String) {
        let alert = UIAlertController(title: "Try again", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension ComputerPlayerTurnViewController: ComputerPlayerTurnViewModelDelegate {
    func dataForAnimation(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol, indexOfNextFieldToShot: Int, stateOfNextFieldToShot: fieldState) {
        let index = NSIndexPath(row: indexOfNextFieldToShot, section: 0)
        let cell = computerPlayerSeaCollectionView.cellForItem(at: index as IndexPath) as! ComputerTurnCustomCollectionViewCell
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.fromValue = cell.contentView.backgroundColor?.cgColor
        if stateOfNextFieldToShot == .free {
            animation.toValue = CustomColors.hitColor?.cgColor
        }
        else if stateOfNextFieldToShot == .hitOccupied {
            animation.toValue = CustomColors.hitOccupiedColor?.cgColor
        }
        animation.duration = 0.8
        cell.contentView.layer.add(animation, forKey: nil)
    }
    
    func computerPlayerWon(_ computerPlayerTurnModel: ComputerPlayerTurnViewModelProtocol, message: String) {
        showAlert(message: message)
    }
    
    func lastShotWasMissedMissed(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol) {
        computerVCDelegate?.sayComputerPlayerMissed(self)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func computerPlayerEnemySea(_ computerPlayerTurnViewModel: ComputerPlayerTurnViewModelProtocol, computerPlayerEnemySea: [[Field]]) {
        computerPlayerEnemySeaMatrix = computerPlayerEnemySea
        guard let computerPlayerSeaCollectionView = computerPlayerSeaCollectionView else {return}
        computerPlayerSeaCollectionView.reloadData()
    }
}

extension ComputerPlayerTurnViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = computerPlayerSeaCollectionView.dequeueReusableCell(withReuseIdentifier: "ComputerTurnCustomCollectionViewCell", for: indexPath) as! ComputerTurnCustomCollectionViewCell
        let row = getRow(forIndexPathRowValue: indexPath.row)
        let column = getColumn(forIndexPathRowValue: indexPath.row)
        let temporaryState = computerPlayerEnemySeaMatrix![row][column].getState()
        cell.actualizeState(newState: temporaryState)
        
        return cell
    }
}
