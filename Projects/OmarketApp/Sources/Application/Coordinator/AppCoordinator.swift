//
//  AppCoordinator.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/17.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem

final class AppCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let splashCoordinator = SplashCoordinator(navigationController: navigationController)
    splashCoordinator.parentCoordinator = self
    childCoordinators.append(splashCoordinator)
    splashCoordinator.start()
  }
  
  func showLogin() {
    let loginCoordinator = LoginCoordinator(navigationController: navigationController)
    loginCoordinator.parentCoordinator = self
    childCoordinators.append(loginCoordinator)
    loginCoordinator.start()
  }

  func showMain() {
    let tabBarController = UITabBarController()
    tabBarController.tabBar.backgroundColor = .systemBackground
    tabBarController.tabBar.tintColor = .label

    let mainNavigationController = UINavigationController()
    let mainCoordinator = MainCoordinator(navigationController: mainNavigationController)
    mainCoordinator.parentCoordinator = self

    mainNavigationController.tabBarItem = UITabBarItem(title: nil, image: ODS.Icon.home, tag: 0)

    tabBarController.viewControllers = [mainNavigationController]
    navigationController.viewControllers = [tabBarController]
    navigationController.setNavigationBarHidden(true, animated: false)

    childCoordinators.append(mainCoordinator)
    mainCoordinator.start()
  }
}
