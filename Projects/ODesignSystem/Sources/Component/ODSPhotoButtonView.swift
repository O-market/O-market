//
//  ODSPhotoButtonView.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/18.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import SnapKit

private class NotHitStackView: UIStackView {
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let hitView = super.hitTest(point, with: event)
    if self == hitView { return nil}
    return hitView
  }
}

public final class ODSPhotoButtonView: UIButton {
  private let roundView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 10
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.systemGray5.cgColor
    view.backgroundColor = .clear
    return view
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = NotHitStackView(
      arrangedSubviews: [cameraImageView, imageCountLabel]
    )
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 2
    return stackView
  }()
  
  private let cameraImageView = UIImageView(image: ODS.Icon.cameraFill)
  
  public let imageCountLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.B_R11
    label.text = "0/10"
    label.textAlignment = .center
    return label
  }()
  
  public init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    cameraImageView.tintColor = .black
    layer.cornerRadius = 10
    layer.borderWidth = 1
    layer.borderColor = UIColor.systemGray5.cgColor
    backgroundColor = .clear
    
    addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview().inset(14)
    }
    cameraImageView.snp.makeConstraints {
      $0.height.equalTo(cameraImageView.snp.width)
      $0.width.equalToSuperview().multipliedBy(0.6)
    }
  }
}
