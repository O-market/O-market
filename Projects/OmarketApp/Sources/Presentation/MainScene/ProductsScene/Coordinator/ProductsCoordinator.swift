//
//  ProductsCoordinator.swift
//  OmarketApp
//
//  Created by 김도연 on 2022/09/02.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class ProductsCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let networkService = NetworkServiceImpl(urlSession: .shared)
    let repository = ProductRepositoryImpl(networkService: networkService)
    let usecase = ProductFetchUseCaseImpl(repository: repository)
    let viewModel = ProductsViewModel(useCase: usecase)
    let viewController = ProductsViewController(viewModel)
    
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func showDetailView(_ id: Int) {
    let detailCoordinator = DetailCoordinator(navigationController: navigationController)
    childCoordinators.append(detailCoordinator)
    detailCoordinator.parentCoordinator = self
    detailCoordinator.start(productId: id)
  }
  
  func showCreateView() {
    let createCoordinator = CreateCoordinator(navigationController: navigationController)
    childCoordinators.append(createCoordinator)
    createCoordinator.parentCoordinator = self
    createCoordinator.start()
  }
}
