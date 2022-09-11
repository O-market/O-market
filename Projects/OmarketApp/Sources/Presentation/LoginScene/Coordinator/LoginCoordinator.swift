//
//  LoginCoordinator.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/11.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class LoginCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let viewModel = LoginViewModel()
    let viewController = LoginViewController(viewModel)
    
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
  
  private func deallocate() {
    parentCoordinator?.removeChildCoordinator(child: self)
  }
}
