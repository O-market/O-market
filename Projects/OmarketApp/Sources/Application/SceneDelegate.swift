//
//  SceneDelegate.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/04.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var appCoordinator: AppCoordinator?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }

    let navigationController = UINavigationController()
    appCoordinator = AppCoordinator(navigationController: navigationController)

    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    appCoordinator?.start()
  }
}
