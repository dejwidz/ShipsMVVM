//
//  CreateGameViewController.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import UIKit

final class CreateGameViewController: UIViewController {
    
    private var mainScrollView: UIScrollView!
    private var projectSea: UICollectionView!
    private var orientationSegmentedControl: UISegmentedControl!
    private var chooseShipSegmentedControl: UISegmentedControl!
    private var generateShipPositionsButton: UIButton!
    private var startGameButton: UIButton!
    
    private var StartGameBottomConstraint = NSLayoutConstraint()
    
    private let vcHumanPlayerTurn = HumanPlayerTurnViewController(rowAndColumnSupplier: RowAndColumn.shared)
    private let viewModel = CreateGameViewModel(model: CreateGameModel(), rowAndColumnSupplier: RowAndColumn.shared)
    private var projectSeaMatrix: [[Field]] = []
    private var humanPlayer: Player?
    private var computerPlayer: Player?
    private var deployPossibility: deploymentPossibility = .unknown
    private var isCellStillHighlighted = false
    private var rowAndColumnSupplier: RowAndColumnSupplier?
    
    init(rowAndColumnSupplier: RowAndColumnSupplier) {
        super.init(nibName: nil, bundle: nil)
        self.rowAndColumnSupplier = rowAndColumnSupplier
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        
        viewModel.createGameViewModelDelegate = self
        viewModel.humanSea()
        viewModel.replaceShipsAutomatically(player: viewModel.computerPlayer!)
        StartGameBottomConstraint.constant = UIScreen.main.bounds.height * 1.2
        projectSea.delegate = self
        projectSea.dataSource = self
    }
    
    private func setupInterface() {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
        view.backgroundColor = CustomColors.backColor
        
        mainScrollView = UIScrollView()
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.contentInsetAdjustmentBehavior = .always
        mainScrollView.backgroundColor = CustomColors.backColor
        mainScrollView.contentSize = CGSize(width: w, height: h)
        mainScrollView.isDirectionalLockEnabled = true
        
        projectSea = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        projectSea.translatesAutoresizingMaskIntoConstraints = false
        projectSea.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "customCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: w * 0.091, height: w * 0.093)
        layout.minimumLineSpacing = w * 0.009
        layout.minimumInteritemSpacing = w * 0.005
        layout.scrollDirection = .horizontal
        projectSea.collectionViewLayout = layout
        projectSea.backgroundColor = CustomColors.backColor
        
        orientationSegmentedControl = UISegmentedControl(items: ["Vertical", "Horizontal"])
        orientationSegmentedControl.selectedSegmentIndex = 0
        orientationSegmentedControl.backgroundColor = CustomColors.tealAndGrayBlue
        orientationSegmentedControl.selectedSegmentTintColor = CustomColors.tealAndGrayBlue
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: CustomColors.fontColor], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: CustomColors.fontColor], for: .selected)
        orientationSegmentedControl.addTarget(self, action: #selector(orientationSegmentedControlValueChanged(_:)), for: .valueChanged)
        orientationSegmentedControl.layer.cornerRadius = h * 0.025
        orientationSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        chooseShipSegmentedControl = UISegmentedControl(items: ["Ship 2", "Ship3", "Ship3", "Ship4", "Ship5"])
        chooseShipSegmentedControl.selectedSegmentIndex = 0
        chooseShipSegmentedControl.backgroundColor = CustomColors.tealAndGrayBlue
        chooseShipSegmentedControl.selectedSegmentTintColor = CustomColors.tealAndGrayBlue
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: CustomColors.fontColor], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: CustomColors.fontColor], for: .selected)
        chooseShipSegmentedControl.addTarget(self, action: #selector(chooseShipSegmentedControlValueChanged(_:)), for: .valueChanged)
        chooseShipSegmentedControl.layer.cornerRadius = h * 0.025
        chooseShipSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        generateShipPositionsButton = UIButton()
        generateShipPositionsButton.translatesAutoresizingMaskIntoConstraints = false
        generateShipPositionsButton.setTitle("Generate Ship Positions", for: .normal)
        generateShipPositionsButton.setTitleColor(CustomColors.fontColor, for: .normal)
        generateShipPositionsButton.backgroundColor = CustomColors.tealAndGrayBlue
        generateShipPositionsButton.layer.cornerRadius = h * 0.025
        generateShipPositionsButton.addTarget(self, action: #selector(generateShipSPositionsButtonTapped(_:)), for: .touchUpInside)
        
        startGameButton = UIButton()
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.setTitle("Start Game", for: .normal)
        startGameButton.setTitleColor(CustomColors.fontColor, for: .normal)
        startGameButton.backgroundColor = CustomColors.tealAndGrayBlue
        startGameButton.layer.cornerRadius = h * 0.025
        startGameButton.addTarget(self, action: #selector(startGameButtonTapped(_:)), for: .touchUpInside)
        
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(projectSea)
        mainScrollView.addSubview(orientationSegmentedControl)
        mainScrollView.addSubview(chooseShipSegmentedControl)
        mainScrollView.addSubview(generateShipPositionsButton)
        mainScrollView.addSubview(startGameButton)
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            projectSea.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            projectSea.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            projectSea.widthAnchor.constraint(equalToConstant: w),
            projectSea.heightAnchor.constraint(equalToConstant: w),
            
            orientationSegmentedControl.topAnchor.constraint(equalTo: projectSea.bottomAnchor, constant: h * 0.05),
            orientationSegmentedControl.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            orientationSegmentedControl.widthAnchor.constraint(equalTo: projectSea.widthAnchor, multiplier: 0.9),
            orientationSegmentedControl.heightAnchor.constraint(equalToConstant: h * 0.05),
            
            chooseShipSegmentedControl.topAnchor.constraint(equalTo: orientationSegmentedControl.bottomAnchor, constant: h * 0.05),
            chooseShipSegmentedControl.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            chooseShipSegmentedControl.widthAnchor.constraint(equalTo: orientationSegmentedControl.widthAnchor),
            chooseShipSegmentedControl.heightAnchor.constraint(equalTo: orientationSegmentedControl.heightAnchor),
            
            generateShipPositionsButton.topAnchor.constraint(equalTo: chooseShipSegmentedControl.bottomAnchor, constant: h * 0.05),
            generateShipPositionsButton.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            generateShipPositionsButton.widthAnchor.constraint(equalTo: chooseShipSegmentedControl.widthAnchor),
            generateShipPositionsButton.heightAnchor.constraint(equalTo: chooseShipSegmentedControl.heightAnchor),
            
            startGameButton.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            startGameButton.widthAnchor.constraint(equalTo: generateShipPositionsButton.widthAnchor),
            startGameButton.heightAnchor.constraint(equalTo: generateShipPositionsButton.heightAnchor)
        ])
        
        StartGameBottomConstraint = startGameButton.topAnchor.constraint(equalTo: generateShipPositionsButton.bottomAnchor, constant: -2000)
        StartGameBottomConstraint.isActive = true
    }
    
    @objc func orientationSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.nextShipOrientation = .vertical
        case 1:
            viewModel.nextShipOrientation = .horizontal
        default:
            print("nothing")
        }
    }
    
    @objc func chooseShipSegmentedControlValueChanged(_ sender: UISegmentedControl) {
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
    
    @objc func generateShipSPositionsButtonTapped(_ sender: Any) {
        viewModel.replaceShipsAutomatically(player: viewModel.humanPlayer!)
        viewModel.startGameButtonAppearanceCounter()
    }
    
    @objc func startGameButtonTapped(_ sender: Any) {
        guard viewModel.startGamePossibility() else {return}
        vcHumanPlayerTurn.setComputerPlayer(computerPlayer: computerPlayer!)
        vcHumanPlayerTurn.setHumanPlayer(humanPlayer: humanPlayer!)
        navigationController?.pushViewController(vcHumanPlayerTurn, animated: true)
    }
    
    private func showMessage(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
   private  func AnimateStartButtonAppearance() {
        let h = UIScreen.main.bounds.height
        UIView.animate(withDuration: 2) {
            self.StartGameBottomConstraint.isActive = false
            NSLayoutConstraint.activate([
                self.startGameButton.topAnchor.constraint(equalTo: self.generateShipPositionsButton.bottomAnchor, constant: h * 0.05)
            ])
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateDeployingPossibility(index: Int, size: Int, orientation: orientation, possibility: Bool) {
        guard isCellStillHighlighted else {return}
        
        let indexOfFieldToAnimate = NSIndexPath(row: index, section: 0)
        let cell = projectSea.cellForItem(at: indexOfFieldToAnimate as IndexPath)
        let toColor: UIColor
        if possibility {
            toColor = CustomColors.freeDeploymentColor ?? .green
        }
        else {
            toColor = CustomColors.occupiedDeploymentColor ?? .orange
        }
        
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.fromValue = cell?.contentView.backgroundColor?.cgColor
        animation.toValue = toColor.cgColor
        animation.duration = 0.15
        cell?.contentView.layer.add(animation, forKey: nil)
        let indexOfNextFieldToAnimate: Int
        let conditionOfSaveAccess: Bool
        if orientation == .horizontal {
            indexOfNextFieldToAnimate = index + 10
            conditionOfSaveAccess = true
        }
        else {
            indexOfNextFieldToAnimate = index - 1
            conditionOfSaveAccess = rowAndColumnSupplier?.getRow(forIndexPathRowValue: index) ?? 0 > 0
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            let sizeCounter = size - 1
            if sizeCounter > 0 && conditionOfSaveAccess {
                self.animateDeployingPossibility(index: indexOfNextFieldToAnimate, size: sizeCounter, orientation: orientation, possibility: possibility)
            }
        }
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
        let row = rowAndColumnSupplier?.getRow(forIndexPathRowValue: indexPath.row) ?? 0
        let column = rowAndColumnSupplier?.getColumn(forIndexPathRowValue: indexPath.row) ?? 0
        let temporaryState = (humanPlayer?.getSea()[row][column].getState())!
        cell.actualizeState(newState: temporaryState)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.checkDeployingPossibility(index: indexPath.row, shipId: viewModel.nextShipId, shipSize: viewModel.nextShipSize, orientation: viewModel.nextShipOrientation)
        viewModel.startGameButtonAppearanceCounter()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        isCellStillHighlighted = true
        viewModel.checkDeployingPossibilityWithoutDeploying(fieldIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        isCellStillHighlighted = false
        deployPossibility = .unknown
        projectSea.reloadData()
    }
}


extension CreateGameViewController: CreateGameViewModelDelegate {
    func sendInfoForAnimation(_ createGameViewModel: CreateGameViewModelProtocol, rowValueOfIndex: Int, size: Int, orientation: orientation, possibilityIndicator: Bool) {
        animateDeployingPossibility(index: rowValueOfIndex, size: size, orientation: orientation, possibility: possibilityIndicator)
    }
    
    func sendInfoThatStartGameButtonCanAppear(_ createGameViewModel: CreateGameViewModelProtocol) {
        AnimateStartButtonAppearance()
    }
    
    func sendInfoAboutDeployingPossibility(_ createGameViewModel: CreateGameViewModelProtocol, info: deploymentPossibility) {
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
