//
//  DownloadTask.swift
//  Magpie
//
//  Created by Lingo on 2022/08/26.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

public protocol DownloadTask {
  func suspend()
  func cancel()
}
