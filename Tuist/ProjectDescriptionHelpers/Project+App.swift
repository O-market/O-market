//
//  Project+App.swift
//  ProjectDescriptionHelpers
//
//  Created by Lingo on 2022/08/04.
//

import ProjectDescription

extension Project {
  public static func app(name: String, packages: [Package] = [], targets: [Target]) -> Project {
    return Project(
      name: "Omarket",
      organizationName: "Omarket",
      options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
      ),
      packages: packages,
      targets: targets,
      schemes: []
    )
  }
}

extension Target {
  public static func appTarget(
    name: String,
    platform: Platform,
    appDependencies: [TargetDependency],
    testDependencies: [TargetDependency]
  ) -> [Target] {
    let appTarget = Target(
      name: name,
      platform: platform,
      product: .app,
      bundleId: "com.omarket.\(name)",
      deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
      infoPlist: .file(path: "Resources/Info.plist"),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: appDependencies
    )
    
    let testTarget = Target(
      name: "\(name)Tests",
      platform: platform,
      product: .unitTests,
      bundleId: "com.omarket.\(name)Tests",
      deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: ["Tests/Resources/**"],
      dependencies: [.target(name: name)] + testDependencies
    )
    
    return [appTarget, testTarget]
  }
}
