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
    let viewControler = ProductsViewController(viewModel)
    
    viewControler.coordinator = self
    navigationController.pushViewController(viewControler, animated: true)
  }
  
  func showDetailView(_ id: Int) {
    // detailCoordinator를 생성하고 start호출
    debugPrint("call showDetailViewController")
  }
  
  func showCreateView() {
    // CreateViewCoordinator를 생성하고 start호출
    debugPrint("call showCreateViewController")
  }
}
