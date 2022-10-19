//
//  ODSLineTextField.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/18.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import SnapKit

public final class ODSLineTextField: UITextField {
  public enum LineLocationStyle {
    case none
    case top
    case bottom
    case all
  }
  
  private let topLineView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray5
    return view
  }()
  
  private let bottomLineView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray5
    return view
  }()
  
  public init(lineStyle: LineLocationStyle) {
    super.init(frame: .zero)
    self.borderStyle = .none
    configureUI(lineStyle)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI(_ lineStyle: LineLocationStyle = .none) {
    if lineStyle == .top || lineStyle == .all {
      addSubview(topLineView)
      
      topLineView.snp.makeConstraints {
        $0.top.equalToSuperview().offset(-8)
        $0.trailing.leading.equalToSuperview()
        $0.width.equalToSuperview()
        $0.height.equalTo(1.0)
      }
    }
    
    if lineStyle == .bottom || lineStyle == .all {
      addSubview(bottomLineView)
      
      bottomLineView.snp.makeConstraints {
        $0.bottom.equalToSuperview().offset(8)
        $0.trailing.leading.equalToSuperview()
        $0.width.equalToSuperview()
        $0.height.equalTo(1.0)
      }
    }
  }
}
