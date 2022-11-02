//
//  CreateCoordinator.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/17.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem

final class CreateCoordinator: Coordinator {
  var navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let network = NetworkServiceImpl()
    let repository = ProductRepositoryImpl(networkService: network)
    let useCase = ProductFetchUseCaseImpl(repository: repository)
    let viewModel = CreateViewModel(useCase: useCase)
    let viewController = CreateViewController(viewModel: viewModel)
    viewController.coordinator = self
    
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func removeCoordinator() {
    parentCoordinator?.childCoordinators.removeAll { $0 === self }
  }
  
  func presentImagePicker(
    limitCount: Int,
    delegate: MSImagePickerDelegate
  ) {
    let imagePicker = MSImagePicker()
    imagePicker.settings.selectionLimit = limitCount
    imagePicker.settings.selectedIndicatorColor = ODS.Color.brand010
    imagePicker.delegate = delegate
    navigationController.present(imagePicker, animated: true)
  }
}
