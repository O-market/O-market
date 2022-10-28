//
//  MultipleImagePickerDelegate.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/27.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

protocol MultipleImagePickerDelegate: AnyObject {
  func picker(picker: UIViewController, results: [ImageManager])
}