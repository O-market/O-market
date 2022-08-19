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

  func showMain() {
    let tabBarController = UITabBarController()

    let mainNavigationController = UINavigationController()
    let mainCoordinator = MainCoordinator(navigationController: mainNavigationController)
    mainCoordinator.parentCoordinator = self

    mainNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)

    tabBarController.viewControllers = [mainNavigationController]
    navigationController.viewControllers = [tabBarController]

    childCoordinators.append(mainCoordinator)
    mainCoordinator.start()
  }
}
