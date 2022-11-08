//
//  DetailCoordinator.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/09/02.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class DetailCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start(productId: Int) {
    let network = NetworkServiceImpl()
    let repository = ProductRepositoryImpl(networkService: network)
    let useCase = ProductFetchUseCaseImpl(repository: repository)
    let viewModel = DetailViewModel(useCase: useCase, productId: productId)
    let viewController = DetailViewController(viewModel: viewModel)
    
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func showEditingView(product: Product) {
    let editingCoordinator = EditingCoordinator(navigationController: navigationController)
    childCoordinators.append(editingCoordinator)
    editingCoordinator.parentCoordinator = self
    editingCoordinator.start(product: product)
  }
}
