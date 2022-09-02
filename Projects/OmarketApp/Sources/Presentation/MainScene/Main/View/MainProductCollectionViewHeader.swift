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
    label.text = "이런 제품은 어떤가요?"
    label.font = ODS.Font.H_B18
    return label
  }()
  private let showAllProductButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = ODS.Font.B_R15
    button.setTitle("전체보기", for: .normal)
    button.setImage(ODS.Icon.chevronRight, for: .normal)
    button.semanticContentAttribute = .forceRightToLeft
    button.imageEdgeInsets = .init(top: 0, left: 4.0, bottom: 0, right: 0)
    button.tintColor = .label
    button.setTitleColor(UIColor.label, for: .normal)
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

  func bind(viewModel: MainViewModelable) {
    showAllProductButton.rx.tap
      .bind(onNext: viewModel.showProductAllScene)
      .disposed(by: disposeBag)
  }

  private func configureUI() {
    self.addSubview(titleLabel)
    self.addSubview(showAllProductButton)

    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
    }

    showAllProductButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(16.0)
    }
  }
}
