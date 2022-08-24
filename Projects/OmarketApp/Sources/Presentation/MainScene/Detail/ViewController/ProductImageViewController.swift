//
//  ProductImageViewController.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/08/21.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

final class ProductImageViewController: UIViewController {
  let imageView: UIImageView
  
  init(image: UIImage) {
    self.imageView = UIImageView(image: image)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
}

// MARK: - UI

extension ProductImageViewController {
  
  private func configureUI() {
    view.addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
