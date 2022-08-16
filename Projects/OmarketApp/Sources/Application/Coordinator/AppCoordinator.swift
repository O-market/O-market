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
    let viewController = UIViewController()
    viewController.view.backgroundColor = ODS.Color.example
    navigationController.pushViewController(viewController, animated: true)
  }
}
