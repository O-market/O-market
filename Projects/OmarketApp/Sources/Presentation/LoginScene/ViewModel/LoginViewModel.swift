//
//  LoginViewModel.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/11.
//  Copyright © 2022 Omarket. All rights reserved.
//

import RxSwift
import RxRelay

protocol LoginViewModelInput {

}

protocol LoginViewModelOutput {
  
}

protocol LoginViewModelType: LoginViewModelInput, LoginViewModelOutput {}

final class LoginViewModel: LoginViewModelType {
  private let disposeBag = DisposeBag()
  
  init() {
    
  }
  
  // MARK: Output
  
}

extension LoginViewModel {
  
  // MARK: Input

}
