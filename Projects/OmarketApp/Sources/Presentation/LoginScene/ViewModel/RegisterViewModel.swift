//
//  RegisterViewModel.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/12.
//  Copyright © 2022 Omarket. All rights reserved.
//

import RxSwift
import RxRelay

protocol RegisterViewModelInput {

}

protocol RegisterViewModelOutput {
  var title: String { get }
}

protocol RegisterViewModelType: RegisterViewModelInput, RegisterViewModelOutput {}

final class RegisterViewModel: RegisterViewModelType {
  private let disposeBag = DisposeBag()
  
  init() {
    
  }
  
  // MARK: Output
  
  let title: String = "회원가입"
}

extension RegisterViewModel {
  
  // MARK: Input

}
