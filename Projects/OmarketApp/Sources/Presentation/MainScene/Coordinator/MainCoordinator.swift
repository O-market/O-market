//
//  MainCoordinator.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/19.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let mainViewModel = MainViewModel()
    let mainViewController = MainViewController(viewModel: mainViewModel)
    navigationController.pushViewController(mainViewController, animated: true)
  }
}
