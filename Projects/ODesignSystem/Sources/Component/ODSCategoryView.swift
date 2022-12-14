//
//  ODSCategoryView.swift
//  ODesignSystem
//
//  Created by Ringo on 2022/09/04.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

public class ODSCategoryView: BaseView {
  private lazy var segmentControl = UISegmentedControl(items: items)
  private lazy var underlineView = UIView()

  /// 외부 열람/설정 가능 프로퍼티
  public var selectedSegmentIndex: Observable<Int> {
    return segmentControl.rx.selectedSegmentIndex.asObservable()
  }

  public var selectedColor: UIColor = ODS.Color.brand010 {
    didSet { setNeedsLayout() }
  }

  private let items: [String]

  public init(items: [String]) {
    self.items = items
    super.init(frame: .zero)
    configureSegmentControl()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    underlineView.backgroundColor = selectedColor
    segmentControl.setTitleTextAttributes(
      [.font: ODS.Font.B_B15, .foregroundColor: selectedColor],
      for: .selected
    )
  }

  override func layout() {
    addSubviews([segmentControl, underlineView])

    segmentControl.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(16.0)
    }

    underlineView.snp.makeConstraints {
      $0.top.equalTo(segmentControl.snp.bottom)
      $0.bottom.equalToSuperview()
      $0.leading.equalTo(segmentControl)
      $0.height.equalTo(4.0)
      $0.width.equalTo(segmentControl).multipliedBy(1 / CGFloat(segmentControl.numberOfSegments))
    }
  }
}

// MARK: - Private Extension

extension ODSCategoryView {
  private func configureSegmentControl() {
    segmentControl.backgroundColor = .systemBackground
    segmentControl.selectedSegmentTintColor = .clear
    segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
    segmentControl.setDividerImage(
      UIImage(),
      forLeftSegmentState: .normal,
      rightSegmentState: .normal,
      barMetrics: .default
    )
    segmentControl.setTitleTextAttributes(
      [.font: ODS.Font.B_R15, .foregroundColor: ODS.Color.gray050],
      for: .normal
    )
    segmentControl.setTitleTextAttributes(
      [.font: ODS.Font.B_B15, .foregroundColor: selectedColor],
      for: .selected
    )
    segmentControl.selectedSegmentIndex = .zero
    segmentControl.addTarget(self, action: #selector(selectedSegmentDidChange), for: .valueChanged)
  }

  @objc private func selectedSegmentDidChange(_ sender: UISegmentedControl) {
    let segmentControlIndex = CGFloat(sender.selectedSegmentIndex)
    let segmentControlWidth = sender.frame.width / CGFloat(sender.numberOfSegments)
    let leadingConstant = segmentControlIndex * segmentControlWidth

    UIView.animate(withDuration: 0.2) {
      self.underlineView.snp.updateConstraints {
        $0.leading.equalTo(self.segmentControl).offset(leadingConstant)
      }
      self.layoutIfNeeded()
    }
  }
}
