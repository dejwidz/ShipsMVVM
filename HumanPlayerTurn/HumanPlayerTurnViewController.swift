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
    let vcComputerPlayerTurn = ComputerPlayerTurnViewController()
    private var lastShotValidation: fieldState = .free
    private var indexOfLastShot: IndexPath?
    private var antiCanningProtector = true
    
    private var humanPlayerSeaCollectionView: UICollectionView!
    private var mainScrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.humanPlayerTurnViewModelDelegate = self
        viewModel.updateHumanPlayerInModel(humanPlayer: humanPlayer!)
        viewModel.updateComputerPlayerInModel(computerPlayer: computerPlayer!)
        vcComputerPlayerTurn.computerVCDelegate = self
        
        setupInterface()
        
        humanPlayerSeaCollectionView.delegate = self
        humanPlayerSeaCollectionView.dataSource = self
        
        vcComputerPlayerTurn.setHumanPlayer(humanPlayer: humanPlayer!)
        vcComputerPlayerTurn.setComputerPlayer(computerPlayer: computerPlayer!)
    }
    
    private func setupInterface() {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        view.backgroundColor = CustomColors.backColor
        
        mainScrollView = UIScrollView()
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.contentInsetAdjustmentBehavior = .always
        mainScrollView.backgroundColor = CustomColors.backColor
        mainScrollView.contentSize = CGSize(width: w, height: w)
        mainScrollView.isDirectionalLockEnabled = true
        
        humanPlayerSeaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        humanPlayerSeaCollectionView.register(PlayerTurnCustomCollectionViewCell.self, forCellWithReuseIdentifier: "PlayerTurnCustomCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: w * 0.091, height: w * 0.093)
        layout.minimumLineSpacing = w * 0.008
        layout.minimumInteritemSpacing = w * 0.005
        layout.scrollDirection = .horizontal
        humanPlayerSeaCollectionView.collectionViewLayout = layout
        humanPlayerSeaCollectionView.translatesAutoresizingMaskIntoConstraints = false
        humanPlayerSeaCollectionView.backgroundColor = CustomColors.backColor
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(humanPlayerSeaCollectionView)
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            humanPlayerSeaCollectionView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            humanPlayerSeaCollectionView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            humanPlayerSeaCollectionView.widthAnchor.constraint(equalToConstant: w),
            humanPlayerSeaCollectionView.heightAnchor.constraint(equalToConstant: w),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        antiCanningProtector = true
    }
    
    func setHumanPlayer(humanPlayer: Player) {
        self.humanPlayer = humanPlayer
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
    func infoAboutLastShotValidation(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayerLastShot: fieldState) {
        lastShotValidation = humanPlayerLastShot
        humanPlayerEnemySeaMatrix![getRow(forIndexPathRowValue: indexOfLastShot!.row)][getColumn(forIndexPathRowValue: indexOfLastShot!.row)].setState(newState: humanPlayerLastShot)
        if humanPlayerLastShot == .hitOccupied {
            antiCanningProtector = true
        }
    }
    
    func turnIndicatorInComputerPlayerVC(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, currentStateOfTurnIndicator: turn) {
        vcComputerPlayerTurn.setTurnIndicator(currentTurn: currentStateOfTurnIndicator)
    }
    
    func humanPlayerEnemySea(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayerEnemySea: [[Field]]) {
        humanPlayerEnemySeaMatrix = humanPlayerEnemySea
    }
    
    func message(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, message: String) {
        showAlert(message: message)
    }
    
    func humanPlayer(_ humanPlayerTurnViewModel: HumanPlayerTurnViewModelProtocol, humanPlayer: Player) {
        self.humanPlayer = humanPlayer
    }
    
}

extension HumanPlayerTurnViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = humanPlayerSeaCollectionView.dequeueReusableCell(withReuseIdentifier: "PlayerTurnCustomCollectionViewCell",
                                                                    for: indexPath) as! PlayerTurnCustomCollectionViewCell
        let row = getRow(forIndexPathRowValue: indexPath.row)
        let column = getColumn(forIndexPathRowValue: indexPath.row)
        let temporaryState = (humanPlayerEnemySeaMatrix![row][column].getState())
        cell.actualizeState(newState: temporaryState)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard antiCanningProtector else {return}
        antiCanningProtector = false
        indexOfLastShot = indexPath
        var nextScreenDisplayPossibility = viewModel.humanPlayerShot(index: indexPath.row)
        let cell = humanPlayerSeaCollectionView.cellForItem(at: indexPath) as! PlayerTurnCustomCollectionViewCell
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.fromValue = cell.contentView.backgroundColor?.cgColor
        if lastShotValidation == .free {
            animation.toValue = CustomColors.hitColor?.cgColor
        }
        else if lastShotValidation == .hitOccupied {
            animation.toValue = CustomColors.hitOccupiedColor?.cgColor
        }
        animation.duration = 0.8
        cell.contentView.layer.add(animation, forKey: nil)
        guard nextScreenDisplayPossibility else {return}
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) { [self] in
            navigationController?.pushViewController(vcComputerPlayerTurn, animated: true)
        }
    }
}


extension HumanPlayerTurnViewController: ComputerTurnVCSendInfoBackDelegate {
    func sayComputerPlayerMissed(_ computerPlayerTurnViewController: ComputerPlayerTurnViewController) {
        viewModel.computerPlayerMissed()
    }  
}
