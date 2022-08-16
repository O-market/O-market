//
//  Project+App.swift
//  ProjectDescriptionHelpers
//
//  Created by Lingo on 2022/08/04.
//

import ProjectDescription

extension Project {
  public static func app(name: String, targets: [Target]) -> Project {
    return Project(
      name: "Omarket",
      organizationName: "Omarket",
      options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
      ),
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
    let infoPlist: [String: InfoPlist.Value] = [
      "CFBundleShortVersionString": "1.0",
      "CFBundleVersion": "1",
      "UIMainStoryboardFile": "",
      "UILaunchStoryboardName": "LaunchScreen",
      "UIApplicationSceneManifest": .dictionary([
        "UIApplicationSupportsMultipleScenes": false,
        "UISceneConfigurations": .dictionary([
          "UIWindowSceneSessionRoleApplication": [
            .dictionary([
              "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
              "UISceneConfigurationName": "Default Configuration",
            ])
          ]
        ])
      ])
    ]
    
    let appTarget = Target(
      name: name,
      platform: platform,
      product: .app,
      bundleId: "com.omarket.\(name)",
      deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
      infoPlist: .extendingDefault(with: infoPlist),
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
