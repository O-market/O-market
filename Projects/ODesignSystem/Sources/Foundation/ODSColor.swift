//
//  ODSColor.swift
//  ODesignSystem
//
//  Created by Lingo on 2022/08/31.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

private extension UIColor {
  convenience init(hex: String, alpha: CGFloat = 1.0) {
    var trimmedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if trimmedHex.hasPrefix("#") {
      trimmedHex = String(trimmedHex.dropFirst())
    }

    assert(trimmedHex.count == 6, "Error: Invalidate hex")

    var rgbValue: UInt64 = 0
    Scanner(string: trimmedHex).scanHexInt64(&rgbValue)

    self.init(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: alpha
    )
  }

  convenience init(light: String, dark: String, alpha: CGFloat = 1.0) {
    self.init { traits -> UIColor in
      let predicate = traits.userInterfaceStyle == .light
      return predicate ? .init(hex: light, alpha: alpha) : .init(hex: dark, alpha: alpha)
    }
  }
}

extension ODS.Color {
  public static let example = UIColor.systemIndigo
  public static let gray000 = UIColor(light: "#FEFEFE", dark: "#171B1C")
  public static let gray010 = UIColor(light: "#FDFDFD", dark: "#1E2427")
  public static let gray020 = UIColor(light: "#F7F8F9", dark: "#2E363A")
  public static let gray030 = UIColor(light: "#E9EBEE", dark: "#41474C")
  public static let gray040 = UIColor(light: "#C5C8CE", dark: "#5A6166")
  public static let gray050 = UIColor(light: "#646F7C", dark: "#999FA4")
  public static let gray060 = UIColor(light: "#374553", dark: "#C5C8CE")
  public static let gray070 = UIColor(light: "#28323C", dark: "#F7F8F9")
  public static let gray080 = UIColor(light: "#161D24", dark: "#FDFDFD")

  public static let black = UIColor(hex: "#000000")
  public static let white = UIColor(hex: "#FFFFFF")

  public static let red050 = UIColor(light: "#FF2C51", dark: "#F26175")

  public static let brand000 = UIColor(hex: "#FCFCFC")
  public static let brand010 = UIColor(hex: "#5D3CD5")
  public static let brand020 = UIColor(hex: "#895DCB")
  public static let brand030 = UIColor(hex: "#B57EC1")
  public static let brand040 = UIColor(hex: "#E1A0B8")
}
