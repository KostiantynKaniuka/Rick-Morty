//
//  SceneDelegate.swift
//  Rick&Morty
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let listViewModel = CharactersListViewModel(networkManager: NetworkManager())


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
               let window = UIWindow(windowScene: windowScene)
               
        let navController = UINavigationController(rootViewController: CharactersListViewController(viewModel: listViewModel))
               window.rootViewController = navController
               window.makeKeyAndVisible()
               self.window = window

        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

