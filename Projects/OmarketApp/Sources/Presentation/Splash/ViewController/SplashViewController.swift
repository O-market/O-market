//
//  SplashViewController.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/19.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import SnapKit

final class SplashViewController: UIViewController {
  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = ODS.Image.logo
    return imageView
  }()

  weak var coordinator: SplashCoordinator?

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
      self?.coordinator?.showMain()
    }
  }
}

// MARK: - UI

extension SplashViewController {
  private func configureUI() {
    view.backgroundColor = ODS.Color.brand050
    view.addSubview(logoImageView)

    logoImageView.snp.makeConstraints {
      $0.centerX.centerY.equalTo(view)
      $0.width.equalTo(200)
      $0.height.equalTo(logoImageView.snp.width).multipliedBy(1.0)
    }
  }
}
