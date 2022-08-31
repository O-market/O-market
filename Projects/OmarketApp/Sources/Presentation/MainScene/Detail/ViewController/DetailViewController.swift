//
//  DetailViewController.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/08/21.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

final class DetailViewController: UIViewController {
  let viewModel: DetailViewModel
  
  let bag = DisposeBag()
  let scrollView = UIScrollView()
  let mainView = DetailView(frame: .zero)
  
  init(viewModel: DetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    configureUI()
  }
}

// MARK: - UI

extension DetailViewController {
  private func configureUI() {
    view.backgroundColor = .systemBackground
    
    self.view.addSubview(scrollView)
    
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    scrollView.addSubview(mainView)
    
    mainView.snp.makeConstraints {
      $0.edges.width.equalToSuperview()
    }
  }
}

extension DetailViewController {
  private func bind() {
    viewModel
      .productImageURL
      .observe(on: MainScheduler.instance)
      .bind(to: mainView.imageCollectionView.rx.items(
        cellIdentifier: ProductImageCell.identifier,
        cellType: ProductImageCell.self)) { row, item, cell in
          cell.setImage(imageURL: item)
        }
        .disposed(by: bag)
    
    viewModel
      .productInfomation
      .observe(on: MainScheduler.instance)
      .subscribe { [weak self] in
        self?.mainView.setContent(content: $0)
      }
      .disposed(by: bag)
    
    viewModel
      .productImageCount
      .observe(on: MainScheduler.instance)
      .subscribe { [weak self] in
        self?.mainView.pageControl.numberOfPages = $0
      }
      .disposed(by: bag)
  }
}
