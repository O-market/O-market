//
//  DetailView.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/08/21.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import SnapKit
import ODesignSystem

final class DetailView: UIView {
  private(set) lazy var imageCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    collectionView.isScrollEnabled = false
    return collectionView
  }()
  
  let pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.currentPage = 0
    pageControl.backgroundStyle = .prominent
    pageControl.hidesForSinglePage = true
    pageControl.isEnabled = false
    return pageControl
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.H_B21

    return label
  }()
  
  private lazy var priceAndStockStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [priceStackView,
                                                   stockStackView])
    return stackView
  }()
  
  private lazy var priceStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [bargainPriceStackView,
                                                   priceLabel])
    stackView.axis = .vertical
    return stackView
  }()
  
  private lazy var bargainPriceStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [discountPercentageLabel,
                                                   discountedPriceStackView])
    stackView.spacing = 8
    return stackView
  }()
  
  private let discountPercentageLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.H_B18
    label.textColor = .systemRed
    label.setContentHuggingPriority(.required, for: .horizontal)
    return label
  }()
  
  private lazy var discountedPriceStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [discountedPriceLabel,
                                                   priceSignLabel])
    stackView.spacing = 4
    return stackView
  }()
  
  private let discountedPriceLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.H_B18
    label.setContentHuggingPriority(.required, for: .horizontal)
    return label
  }()
  
  private let priceSignLabel: UILabel = {
    let label = UILabel()
    label.text = "원"
    label.font = ODS.Font.H_B18
    return label
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.B_R13
    label.textColor = .systemGray3
    return label
  }()
  
  private lazy var stockStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [stockGuideLabel,
                                                   stockLabel])
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private let stockGuideLabel: UILabel = {
    let label = UILabel()
    label.text = "잔여 수량"
    label.font = ODS.Font.B_R13
    label.textAlignment = .center
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    return label
  }()
  
  private let stockLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.H_B16
    label.textAlignment = .center
    label.setContentHuggingPriority(.required, for: .horizontal)
    return label
  }()
  
  private lazy var informationStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [informationGuideLabel,
                                                   informationLabel])
    stackView.axis = .vertical
    stackView.spacing = 24
    return stackView
  }()
  
  private let informationGuideLabel: UILabel = {
    let label = UILabel()
    label.text = "상품 상세 정보"
    label.font = ODS.Font.H_B16
    return label
  }()
  
  private let informationLabel: UILabel = {
    let label = UILabel()
    label.font = ODS.Font.H_R16
    label.numberOfLines = 0
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(imageCollectionView)
    imageCollectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
    
    imageCollectionView.snp.makeConstraints {
      $0.trailing.leading.top.equalToSuperview()
      $0.width.equalToSuperview()
      $0.height.equalTo(imageCollectionView.snp.width).multipliedBy(40/39)
    }
    
    addSubview(pageControl)
    
    pageControl.snp.makeConstraints {
      $0.bottom.equalTo(imageCollectionView.snp.bottom).inset(15)
      $0.centerX.equalToSuperview()
    }
    
    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.imageCollectionView.snp.bottom).inset(-16)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
    
    addSubview(priceAndStockStackView)
    
    priceAndStockStackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).inset(-16)
      $0.leading.trailing.equalToSuperview().inset(24)
    }
    
    addSubview(informationStackView)
    
    informationStackView.snp.makeConstraints {
      $0.top.equalTo(priceAndStockStackView.snp.bottom).inset(-32)
      $0.leading.trailing.bottom.equalToSuperview().inset(16)
    }
  }
  
  func setContent(content: DetailViewModelItem) {
    titleLabel.text = content.title
    informationLabel.text = content.body
    stockLabel.text = content.stock
    priceLabel.text = content.price
    discountedPriceLabel.text = content.bargainPrice
    discountPercentageLabel.text = content.discountPercentage
  }
}

extension DetailView {
  var collectionViewLayout: UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1),
                                           heightDimension: .fractionalHeight(1))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .paging
    
    section.visibleItemsInvalidationHandler = { [weak self] _, point, environment in
      let currentPoint = point.x
      let collectionViewWidth = environment.container.contentSize.width
      
      let currentPage = round(currentPoint / collectionViewWidth)
      
      self?.pageControl.currentPage = Int(currentPage)
    }
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}
