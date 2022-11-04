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
    let repository = ProductRepositoryImpl(networkService: NetworkServiceImpl(urlSession: .shared))
    let useCase = ProductFetchUseCaseImpl(repository: repository)
    let mainViewModel = MainViewModel(useCase: useCase)
    mainViewModel.coordinator = self
    let mainViewController = MainViewController(viewModel: mainViewModel)
    navigationController.pushViewController(mainViewController, animated: true)
  }

  func showProductsScene() {
    let productsCoordinator = ProductCoordinator(navigationController: navigationController)
    childCoordinators.append(productsCoordinator)
    productsCoordinator.parentCoordinator = self
    productsCoordinator.start()
  }
}
