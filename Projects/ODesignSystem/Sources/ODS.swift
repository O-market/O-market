//
//  ODS.swift
//  ODesignSystem
//
//  Created by Lingo on 2022/08/05.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

public enum ODS {
  public enum Color {
    public static let example = UIColor.systemIndigo
  }
  public enum Image {
    public static let logo = UIImage(named: "Logo")
  }
  public enum Icon {
    public static let home = UIImage(systemName: "house.fill")
  }
  public enum Font {
    static let B_R9 = UIFont.systemFont(ofSize: 9.0, weight: .regular)
    static let B_R11 = UIFont.systemFont(ofSize: 11.0, weight: .regular)
    static let B_M11 = UIFont.systemFont(ofSize: 11.0, weight: .medium)
    static let B_B11 = UIFont.systemFont(ofSize: 11.0, weight: .bold)
    static let B_R13 = UIFont.systemFont(ofSize: 13.0, weight: .regular)
    static let B_B13 = UIFont.systemFont(ofSize: 13.0, weight: .bold)
    static let B_R15 = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    static let B_M15 = UIFont.systemFont(ofSize: 15.0, weight: .medium)
    static let B_B15 = UIFont.systemFont(ofSize: 15.0, weight: .bold)
    static let H_R16 = UIFont.systemFont(ofSize: 16.0, weight: .regular)
    static let H_M16 = UIFont.systemFont(ofSize: 16.0, weight: .medium)
    static let H_B16 = UIFont.systemFont(ofSize: 16.0, weight: .bold)
    static let H_M18 = UIFont.systemFont(ofSize: 18.0, weight: .medium)
    static let H_B18 = UIFont.systemFont(ofSize: 18.0, weight: .bold)
    static let H_B21 = UIFont.systemFont(ofSize: 21.0, weight: .bold)
    static let H_B24 = UIFont.systemFont(ofSize: 24.0, weight: .bold)
    static let H_B36 = UIFont.systemFont(ofSize: 36.0, weight: .bold)
  }
}
