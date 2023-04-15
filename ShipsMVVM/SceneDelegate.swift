//
//  SceneDelegate.swift
//  ShipsMVVM
//
//  Created by Dawid Zimoch on 17/05/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
        
        let homeViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
