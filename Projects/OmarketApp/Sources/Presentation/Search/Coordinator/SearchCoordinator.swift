//
//  SearchCoordinator.swift
//  OmarketApp
//
//  Created by Ringo on 2022/11/21.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class SearchCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {}
}
