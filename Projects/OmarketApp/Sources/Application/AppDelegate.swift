//
//  AppDelegate.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/04.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import FirebaseCore
import KakaoSDKCommon

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    KakaoSDK.initSDK(appKey: "e769b65347e952eb5e2c724825493195")
    return true
  }
  
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    UISceneConfiguration(
      name: "Default Configuration",
      sessionRole: connectingSceneSession.role
    )
  }
}
