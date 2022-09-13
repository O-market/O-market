//
//  GoogleLoginManager.swift
//  OmarketApp
//
//  Created by 조민호 on 2022/09/13.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxSwift
import FirebaseAuth
import GoogleSignIn

final class GoogleLoginManager: NSObject {
  private weak var viewController: UIViewController?
  private let signInConfig = GIDConfiguration.init(clientID: "569221289737-601qs6jtrgjdti1fhblfog5q00ab2ibs.apps.googleusercontent.com")
  
  let completed = PublishSubject<Void>()
  let error = PublishSubject<Void>()
  
  init(viewController: UIViewController) {
    self.viewController = viewController
  }
}

extension GoogleLoginManager {
  func startSignInWithGoogleFlow() {
    guard let viewController = viewController else {
      return
    }
    
    GIDSignIn.sharedInstance.signIn(
      with: signInConfig,
      presenting: viewController
    ) { user, error in
        guard error == nil else { return }
        guard let user = user else { return }
        
        if let error = error {
          print("ERROR Google Sign In \(error.localizedDescription)")
          return
        }
        
        let authentication = user.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { [weak self] result, error in
          if let error = error {
            self?.error.onNext(())
            return
          }
          
          UserDefaultsManager.USER_EMAIL = result?.user.email ?? ""
          self?.completed.onNext(())
        }
      }
  }
}
