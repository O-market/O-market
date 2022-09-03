//
//  MainProductCollectionViewHeader.swift
//  OmarketApp
//
//  Created by Lingo on 2022/09/02.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import RxCocoa
import RxSwift
import SnapKit

final class MainProductCollectionViewHeader: UICollectionReusableView {
  static let identifier = "MainProductCollectionViewHeader"

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.H_B16
    label.text = "이런 제품은 어떤가요?"

    return label
  }()

  private let showProductsButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = ODS.Font.B_R13
    button.imageView?.contentMode = .scaleAspectFit
    button.semanticContentAttribute = .forceRightToLeft
    button.imageEdgeInsets = .init(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)

    button.tintColor = .label
    button.setTitleColor(UIColor.label, for: .normal)

    button.setTitle("전체보기", for: .normal)
    button.setImage(ODS.Icon.chevronRight, for: .normal)

    return button
  }()

  private let disposeBag = DisposeBag()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func bind(with viewModel: MainViewModelable) {
    showProductsButton.rx.tap
      .bind(onNext: viewModel.showProductsButtonDidTapEvent)
      .disposed(by: disposeBag)
  }

  private func configureUI() {
    addSubviews([titleLabel, showProductsButton])

    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
    }

    showProductsButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(16.0)
    }
  }
}
