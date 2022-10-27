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
  static let rgMagpie: TargetDependency = .external(name: "RGMagpie")
}
