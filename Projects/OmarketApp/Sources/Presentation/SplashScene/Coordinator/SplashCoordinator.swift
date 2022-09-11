//
//  SplashCoordinator.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/19.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class SplashCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let splashViewController = SplashViewController()
    splashViewController.coordinator = self
    splashViewController.modalPresentationStyle = .fullScreen
    navigationController.present(splashViewController, animated: false)
  }
  
  func showLogin() {
    let appCoordinator = parentCoordinator as? AppCoordinator
    appCoordinator?.showLogin()
    navigationController.dismiss(animated: true)
    deallocate()
  }

  func showMain() {
    let appCoordinator = parentCoordinator as? AppCoordinator
    appCoordinator?.showMain()
    navigationController.dismiss(animated: true)
    deallocate()
  }

  private func deallocate() {
    parentCoordinator?.removeChildCoordinator(child: self)
  }
}
