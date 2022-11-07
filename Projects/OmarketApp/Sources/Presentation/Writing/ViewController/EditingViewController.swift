//
//  EditingViewController.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/11/07.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

final class EditingViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let mainView = WritingView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI

extension EditingViewController {
  private func configureUI() {
    view.backgroundColor = .systemBackground
    view.addSubview(mainView)
    mainView.photoButton.isHidden = true
    mainView.snp.makeConstraints {
      $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
