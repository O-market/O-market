//
//  Dependency+Extension.swift
//  Config
//
//  Created by Lingo on 2022/08/04.
//

import ProjectDescription

public extension TargetDependency {
  static let rxSwift: TargetDependency = .external(name: "RxSwift")
  static let rxRelay: TargetDependency = .external(name: "RxRelay")
  static let rxCocoa: TargetDependency = .external(name: "RxCocoa")
  static let rxTest: TargetDependency = .external(name: "RxTest")
  static let rxDataSources: TargetDependency = .external(name: "RxDataSources")
  static let snapKit: TargetDependency = .external(name: "SnapKit")
  static let rxKakaoSDKAuth: TargetDependency = .external(name: "RxKakaoSDKAuth")
  static let rxKakaoSDKCommon: TargetDependency = .external(name: "RxKakaoSDKCommon")
  static let rxKakaoSDKUser: TargetDependency = .external(name: "RxKakaoSDKUser")
  static let firebaseAuth: TargetDependency = .package(product: "FirebaseAuth")
}

// MARK: - Package

public extension Package {
  static let firebase: Package = .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .exact("9.5.0"))
}
