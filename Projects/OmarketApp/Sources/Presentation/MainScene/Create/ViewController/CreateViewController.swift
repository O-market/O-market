//
//  CreateViewController.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/18.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

class CreateViewController: UIViewController {
  private let disposeBag = DisposeBag()
  weak var coordinator: CreateCoordinator?
  private let mainView = CreateView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind()
    
  }
}

// MARK: - UI

extension CreateViewController {
  private func configureUI() {
    title = "글쓰기"
    view.backgroundColor = .systemBackground
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

// MARK: - Extension

extension CreateViewController {
  private func bind() {
    mainView.textView.rx.text
      .orEmpty
      .map { !$0.isEmpty }
      .distinctUntilChanged()
      .bind(to: mainView.placeholderLabel.rx.isHidden)
      .disposed(by: disposeBag)
    
    mainView.photoButton.rx.tap
      .bind {
      }.disposed(by: disposeBag)
  }
}
