//
//  KakaoLoginManager.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/13.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxSwift
import FirebaseAuth
import RxKakaoSDKUser
import KakaoSDKUser

final class KakaoLoginManager: NSObject {
  private weak var viewController: UIViewController?
  private let disposeBag = DisposeBag()
  
  let completed = PublishSubject<Void>()
  let error = PublishSubject<Void>()
  
  private let completedKakaoLogin = PublishSubject<Void>()
  
  init(viewController: UIViewController) {
    self.viewController = viewController
    super.init()
    bind()
  }
  
  private func bind() {
    completedKakaoLogin
      .subscribe (onNext: { [weak self] in
        UserApi.shared.me { user, error in
          if let _ = error {
            self?.error.onNext(())
          }
          
          let email = user?.kakaoAccount?.email ?? ""
          
          Auth.auth().createUser(withEmail: email, password: "Kakao\(email)") { _, _ in
            Auth.auth().signIn(withEmail: email, password: "Kakao\(email)") { [weak self] result, error in
              if let _ = error {
                self?.error.onNext(())
                return
              }
                            
              UserDefaultsManager.USER_EMAIL = result?.user.email ?? ""
              self?.completed.onNext(())
            }
          }
        }
      })
      .disposed(by: disposeBag)
  }
}

extension KakaoLoginManager {
  func startSignInWithKakaoFlow() {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.rx.loginWithKakaoTalk()
        .subscribe(onNext:{ [weak self] _ in
          self?.completedKakaoLogin.onNext(())
        }, onError: { [weak self] _ in
          self?.error.onNext(())
        })
        .disposed(by: disposeBag)
    } else {
      UserApi.shared.rx.loginWithKakaoAccount()
        .subscribe(onNext:{ [weak self] _ in
          self?.completedKakaoLogin.onNext(())
        }, onError: { [weak self] _ in
          self?.error.onNext(())
        })
        .disposed(by: disposeBag)
    }
  }
}
