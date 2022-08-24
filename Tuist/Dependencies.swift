//
//  Dependencies.swift
//  Config
//
//  Created by Lingo on 2022/08/04.
//

import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: [
    .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.5.0")),
    .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .exact("5.6.0")),
    .remote(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", requirement: .exact("5.0.2")),
    .remote(url: "https://github.com/kakao/kakao-ios-sdk-rx.git", requirement: .exact("2.9.1"))
  ],
  platforms: [.iOS]
)
