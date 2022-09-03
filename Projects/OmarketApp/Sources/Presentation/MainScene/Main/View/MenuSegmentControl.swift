//
//  MenuSegmentControl.swift
//  OmarketApp
//
//  Created by Lingo on 2022/09/03.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import SnapKit

final class MenuSegmentControl: UIView {
  private lazy var segmentControl: UISegmentedControl = {
    let segmentControl = UISegmentedControl()
    segmentControl.backgroundColor = .systemBackground
    segmentControl.selectedSegmentTintColor = .clear
    segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
    segmentControl.setDividerImage(
      UIImage(),
      forLeftSegmentState: .normal,
      rightSegmentState: .normal,
      barMetrics: .default
    )
    segmentControl.setTitleTextAttributes([
      NSAttributedString.Key.font: ODS.Font.B_R15,
      NSAttributedString.Key.foregroundColor: ODS.Color.gray050
    ], for: .normal)

    segmentControl.setTitleTextAttributes([
      NSAttributedString.Key.font: ODS.Font.B_B15,
      NSAttributedString.Key.foregroundColor: ODS.Color.brand010
    ], for: .selected)

    segmentControl.insertSegment(withTitle: "오픈마켓", at: 0, animated: true)
    segmentControl.insertSegment(withTitle: "매거진", at: 1, animated: true)
    segmentControl.addTarget(self, action: #selector(segmentControlDidChange), for: .valueChanged)
    segmentControl.selectedSegmentIndex = 0

    return segmentControl
  }()

  private let underLineView: UIView = {
    let view = UIView()
    view.backgroundColor = ODS.Color.brand010

    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc private func segmentControlDidChange(_ sender: UISegmentedControl) {
    let segmentControlIndex = CGFloat(sender.selectedSegmentIndex)
    let segmentControlWidth = sender.frame.width / CGFloat(sender.numberOfSegments)
    let leadingDistance = segmentControlIndex * segmentControlWidth

    UIView.animate(withDuration: 0.2) { [weak self] in
      guard let self = self else { return }
      self.underLineView.snp.updateConstraints {
        $0.leading.equalTo(self.segmentControl).offset(leadingDistance)
      }
      self.layoutIfNeeded()
    }
  }
}

// MARK: - UI

extension MenuSegmentControl {
  private func configureUI() {
    self.backgroundColor = .systemBackground
    [segmentControl, underLineView].forEach { addSubview($0) }

    segmentControl.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(16.0)
      $0.height.equalTo(43.0)
    }
    underLineView.snp.makeConstraints {
      $0.top.equalTo(segmentControl.snp.bottom)
      $0.height.equalTo(5.0)
      $0.leading.equalTo(segmentControl.snp.leading)
      $0.width.equalTo(segmentControl).multipliedBy(1 / CGFloat(segmentControl.numberOfSegments))
    }
  }
}
