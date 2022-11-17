//
//  CreationCoordinator.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/17.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import SFImagePicker

final class CreationCoordinator: Coordinator {
  let navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let network = NetworkServiceImpl()
    let repository = ProductRepositoryImpl(networkService: network)
    let useCase = ProductFetchUseCaseImpl(repository: repository)
    let viewModel = CreationViewModel(useCase: useCase, imageCountMax: 5, imageCountMin: 1)
    let viewController = CreationViewController(viewModel: viewModel)
    viewController.coordinator = self
    
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func removeCoordinator() {
    parentCoordinator?.removeChildCoordinator(child: self)
  }
  
  func presentImagePicker(
    selectionMin: Int,
    selectionMax: Int,
    onSelected: @escaping ((SFImageManager) -> Void),
    onDeSelcted: @escaping ((SFImageManager) -> Void),
    onCanceled: @escaping (([SFImageManager]) -> Void)
  ) {
    let imagePicker = SFImagePicker()
    imagePicker.settings.selection.max = selectionMax
    imagePicker.settings.selection.min = selectionMin
    imagePicker.settings.ui.selectedIndicatorColor = ODS.Color.brand010
    navigationController.presentImagePicker(
      imagePicker,
      animated: true,
      onSelection: onSelected,
      onDeSelction: onDeSelcted,
      onCancel: onCanceled
    )
  }
}
