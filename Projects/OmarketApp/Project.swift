//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Lingo on 2022/08/04.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "OmarketApp",
  targets: Target.appTarget(
    name: "OmarketApp",
    platform: .iOS,
    appDependencies: [
      .project(target: "ODesignSystem", path: "../ODesignSystem"),
      .snapKit,
      .rxSwift,
      .rxCocoa,
      .rxRelay,
      .rxDataSources,
      .rgMagpie,
      .sfImagePicker
    ],
    testDependencies: [
      .rxSwift,
      .rxRelay,
      .rxTest
    ]
  )
)
