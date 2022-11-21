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

  func start() {
    let repository = ProductRepositoryImpl(networkService: NetworkServiceImpl(urlSession: .shared))
    let useCase = ProductFetchUseCaseImpl(repository: repository)
    let searchViewModel = SearchViewModel(useCase: useCase)
    searchViewModel.coordinator = self
    let searchViewController = SearchViewController(viewModel: searchViewModel)
    navigationController.pushViewController(searchViewController, animated: true)
  }

  func showDetailView(_ id: Int) {
    let detailCoordinator = DetailCoordinator(navigationController: navigationController)
    childCoordinators.append(detailCoordinator)
    detailCoordinator.parentCoordinator = self
    detailCoordinator.start(productId: id)
  }
}
