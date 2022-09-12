//
//  EmailLoginCoordinator.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/12.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class EmailLoginCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  weak var appCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let viewModel = EmailLoginViewModel()
    let viewController = EmailLoginViewController(viewModel)
    
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func showRegister() {
    let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
    registerCoordinator.parentCoordinator = self
    registerCoordinator.appCoordinator = appCoordinator
    childCoordinators.append(registerCoordinator)
    registerCoordinator.start()
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
