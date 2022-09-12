//
//  RegisterCoordinator.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/12.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class RegisterCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  weak var appCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let viewModel = RegisterViewModel()
    let viewController = RegisterViewController(viewModel)
    
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func showMain() {
    let appCoordinator = appCoordinator as? AppCoordinator
    appCoordinator?.showMain()
    navigationController.dismiss(animated: true)
    deallocate()
  }
  
  func deallocate() {
    parentCoordinator?.removeChildCoordinator(child: self)
  }
}
