//
//  EmailLoginViewModel.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/12.
//  Copyright © 2022 Omarket. All rights reserved.
//

import RxSwift
import RxRelay
import FirebaseAuth

protocol EmailLoginViewModelInput {
  var email: BehaviorRelay<String> { get }
  var password: BehaviorRelay<String> { get }
  
  func didTapLoginButton()
}

protocol EmailLoginViewModelOutput {
  var title: String { get }
  var loginButtonValidation: Observable<Bool> { get }
  var successLogin: PublishSubject<Void> { get }
  var error: PublishSubject<Void> { get }
}

protocol EmailLoginViewModelType: EmailLoginViewModelInput, EmailLoginViewModelOutput {}

final class EmailLoginViewModel: EmailLoginViewModelType {
  private let disposeBag = DisposeBag()
  
  init() {
    
  }
  
  // MARK: Output
  
  let title: String = "로그인"
  var loginButtonValidation: Observable<Bool> {
    return Observable.combineLatest(email, password)
      .map { email, password in
        return !email.isEmpty && !password.isEmpty
      }
  }
  let successLogin = PublishSubject<Void>()
  let error = PublishSubject<Void>()
  
  // MARK: Input
  
  let email = BehaviorRelay<String>(value: "")
  let password = BehaviorRelay<String>(value: "")
}

extension EmailLoginViewModel {
  
  // MARK: Input
  
  func didTapLoginButton() {
    Auth.auth().signIn(withEmail: email.value, password: password.value) { [weak self] result, error in
      if let _ = error {
        self?.error.onNext(())
        return
      }
      
      UserDefaultsManager.USER_EMAIL = result?.user.email ?? ""
      self?.successLogin.onNext(())
    }
  }
}
