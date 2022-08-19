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
    let vc = UIViewController()
    vc.view.backgroundColor = .systemIndigo
    navigationController.pushViewController(vc, animated: true)
  }
}
