//
//  ODSPhotoButtonView.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/18.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import SnapKit

public final class ODSPhotoButtonView: UIButton {
  private let roundView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 10
    view.layer.borderWidth = 5
    view.layer.borderColor = UIColor.systemGray5.cgColor
    view.backgroundColor = .clear
    return view
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [cameraImageView, imageCountLabel])
    stackView.axis = .vertical
    stackView.spacing = 2
    return stackView
  }()
  
  private let cameraImageView = UIImageView(image: .init(systemName: "camera.fill"))
  
  private let imageCountLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 11)
    label.text = "0/10"
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
    addSubview(roundView)
    roundView.addSubview(stackView)
    
    roundView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview().inset(16)
    }
    stackView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }
  }
}
