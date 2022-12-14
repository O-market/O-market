//
//  MainProductHeader.swift
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

final class MainProductHeader: UICollectionReusableView {
  static let identifier = "MainProductHeader"

  // MARK: Interfaces

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.H_B18
    label.text = "이런 제품은 어떤가요?"
    return label
  }()

  private let showProductButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = ODS.Font.B_R15
    button.imageView?.contentMode = .scaleAspectFit
    button.semanticContentAttribute = .forceRightToLeft
    button.imageEdgeInsets = .init(top: 4.0, left: 8.0, bottom: 4.0, right: 4.0)
    button.tintColor = .label
    button.setTitleColor(UIColor.label, for: .normal)
    button.setTitle("전체보기", for: .normal)
    button.setImage(ODS.Icon.chevronRight, for: .normal)
    return button
  }()

  // MARK: Properties

  private var disposeBag = DisposeBag()

  // MARK: Life Cycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }

  // MARK: Methods

  func bind(viewModel: MainViewModelable) {
    disposeBag = DisposeBag()

    showProductButton.rx.tap
      .bind(onNext: viewModel.showProductsButtonDidTapEvent)
      .disposed(by: disposeBag)
  }

  // MARK: Helpers

  private func configureUI() {
    addSubviews([titleLabel, showProductButton])

    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
    }

    showProductButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-16.0)
    }
  }
}
