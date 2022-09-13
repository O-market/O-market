//
//  RegisterViewModel.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/12.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxSwift
import RxRelay
import FirebaseAuth

protocol RegisterViewModelInput {
  var email: BehaviorRelay<String> { get }
  var password: BehaviorRelay<String> { get }
  var checkedPassword: BehaviorRelay<String> { get }
  func didTapRegisterButton()
}

protocol RegisterViewModelOutput {
  var title: String { get }
  var emailValidation: Bool { get }
  var passwordValidation: Bool { get }
  var checkedPasswordValidation: Bool { get }
  var registerButtonValidation: Observable<Bool> { get }
  var successRegister: PublishSubject<Void> { get }
  var error: PublishSubject<Void> { get }
}

protocol RegisterViewModelType: RegisterViewModelInput, RegisterViewModelOutput {}

final class RegisterViewModel: RegisterViewModelType {
  private let disposeBag = DisposeBag()
  
  init() {
    
  }
  
  // MARK: Output
  
  let title: String = "회원가입"
  var emailValidation: Bool {
    return checkValidEmail(email.value)
  }
  var passwordValidation: Bool {
    return checkValidPassword(password.value)
  }
  var checkedPasswordValidation: Bool {
    return checkValidCheckedPassword(checkedPassword.value)
  }
  var registerButtonValidation: Observable<Bool> {
    return Observable.combineLatest(email, password, checkedPassword)
      .map { [weak self] _, _, _ in
        guard let self = self else { return false }
        return self.emailValidation && self.passwordValidation && self.checkedPasswordValidation
      }
  }
  let successRegister = PublishSubject<Void>()
  let error = PublishSubject<Void>()
  
  // MARK: Input
  
  let email = BehaviorRelay<String>(value: "")
  let password = BehaviorRelay<String>(value: "")
  let checkedPassword = BehaviorRelay<String>(value: "")
}

extension RegisterViewModel {
  
  // MARK: Input
  
  func didTapRegisterButton() {
    Auth.auth().createUser(withEmail: email.value, password: password.value) { [weak self] result, error in
      if let _ = error {
        self?.error.onNext(())
        return
      }
      
      UserDefaultsManager.USER_EMAIL = result?.user.email ?? ""
      self?.successRegister.onNext(())
    }
  }
}

extension RegisterViewModel {
  private func checkValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPredicate.evaluate(with: email)
  }
  
  private func checkValidPassword(_ password: String) -> Bool {
    let passwordRegEx = "^[a-zA-Z0-9]{10,}$"
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
    return passwordPredicate.evaluate(with: password)
  }
  
  private func checkValidCheckedPassword(_ checkedPassword: String) -> Bool {
    return password.value == checkedPassword
  }
}
