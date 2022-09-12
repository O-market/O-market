//
//  RegisterViewController.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/12.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxSwift

final class RegisterViewController: UIViewController {

  private let viewModel: RegisterViewModelType
  private let disposeBag = DisposeBag()
  weak var coordinator: RegisterCoordinator?
  
  init(_ viewModel: RegisterViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    
    view = RegisterView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bind()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    coordinator?.deallocate()
  }
  
  private func bind() {
    guard let view = view as? RegisterView else { return }
    
    self.title = viewModel.title
    
    view.registerButton.rx.tap
      .bind { [weak self] in
        self?.coordinator?.showMain()
      }
      .disposed(by: disposeBag)
  }
}

