//
//  EmailLoginViewController.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/12.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxSwift

final class EmailLoginViewController: UIViewController {

  private let viewModel: EmailLoginViewModelType
  private let disposeBag = DisposeBag()
  weak var coordinator: EmailLoginCoordinator?
  
  init(_ viewModel: EmailLoginViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    
    view = EmailLoginView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigation()
    bind()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if self.isMovingFromParent {
      coordinator?.deallocate()
    }
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func bind() {
    guard let view = view as? EmailLoginView else { return }
    
    self.title = viewModel.title
    
    view.registerButton.rx.tap
      .bind { [weak self] in
        self?.coordinator?.showRegister()
      }
      .disposed(by: disposeBag)
  }
}
