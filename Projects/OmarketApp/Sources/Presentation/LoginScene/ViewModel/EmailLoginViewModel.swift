//
//  EmailLoginViewModel.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/12.
//  Copyright © 2022 Omarket. All rights reserved.
//

import RxSwift
import RxRelay

protocol EmailLoginViewModelInput {

}

protocol EmailLoginViewModelOutput {
  var title: String { get }
}

protocol EmailLoginViewModelType: EmailLoginViewModelInput, EmailLoginViewModelOutput {}

final class EmailLoginViewModel: EmailLoginViewModelType {
  private let disposeBag = DisposeBag()
  
  init() {
    
  }
  
  // MARK: Output
  
  let title: String = "로그인"
}

extension EmailLoginViewModel {
  
  // MARK: Input

}
