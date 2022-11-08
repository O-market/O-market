//
//  EditingCoordinator.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/11/08.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class EditingCoordinator: Coordinator {
  var navigationController: UINavigationController
  var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start(product: Product) {
    let network = NetworkServiceImpl()
    let repository = ProductRepositoryImpl(networkService: network)
    let useCase = ProductFetchUseCaseImpl(repository: repository)
    let viewModel = EditingViewModel(useCase: useCase, product: product)
    let viewController = EditingViewController(viewModel: viewModel)
    viewController.coordinator = self
    
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func removeCoordinator() {
    parentCoordinator?.removeChildCoordinator(child: self)
  }
}
