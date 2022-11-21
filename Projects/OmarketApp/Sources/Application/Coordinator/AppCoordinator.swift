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
    tabBarController.tabBar.backgroundColor = .systemBackground
    tabBarController.tabBar.tintColor = .label

    let mainNavigationController = UINavigationController()
    mainNavigationController.tabBarItem = UITabBarItem(title: "홈", image: ODS.Icon.home, tag: 0)
    mainNavigationController.navigationBar.tintColor = .label

    let searchNavigationController = UINavigationController()
    searchNavigationController.tabBarItem = UITabBarItem(title: "검색", image: ODS.Icon.search, tag: 1)
    searchNavigationController.navigationBar.tintColor = .label

    tabBarController.viewControllers = [mainNavigationController, searchNavigationController]
    navigationController.viewControllers = [tabBarController]
    navigationController.setNavigationBarHidden(true, animated: false)

    let mainCoordinator = MainCoordinator(navigationController: mainNavigationController)
    let searchCoordinator = SearchCoordinator(navigationController: searchNavigationController)
    mainCoordinator.parentCoordinator = self
    searchCoordinator.parentCoordinator = self

    childCoordinators.append(mainCoordinator)
    childCoordinators.append(searchCoordinator)
    mainCoordinator.start()
    searchCoordinator.start()
  }
}
