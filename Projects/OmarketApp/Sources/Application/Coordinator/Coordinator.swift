//
//  Coordinator.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/17.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
  var navigationController: UINavigationController { get }
  var parentCoordinator: Coordinator? { get set }
  var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
  func removeChildCoordinator(child: Coordinator) {
    childCoordinators.removeAll { $0 === child }
  }
}
