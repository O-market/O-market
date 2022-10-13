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
      .project(target: "Magpie", path: "../Magpie"),
      .project(target: "ODesignSystem", path: "../ODesignSystem"),
      .snapKit,
      .rxSwift,
      .rxCocoa,
      .rxRelay,
      .rxDataSources
    ],
    testDependencies: [
      .rxSwift,
      .rxRelay,
      .rxTest
    ]
  )
)
