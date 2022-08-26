//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Lingo on 2022/08/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticFramework(
  name: "Magpie",
  targets: Target.staticFrameworkTargets(
    name: "Magpie",
    platform: .iOS,
    appDependencies: [],
    testDependencies: []
  )
)
