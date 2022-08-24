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
  let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                navigationOrientation: .horizontal)
  
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
    
    guard let image = UIImage(systemName: "swift") else { return }
    let startVC = ProductImageViewController(image: image)
    
    pageViewController.setViewControllers([startVC],
                                          direction: .reverse,
                                          animated: true)
    
    self.addChild(pageViewController)
    self.view.addSubview(scrollView)
    
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    scrollView.addSubview(pageViewController.view)
    
    pageViewController.view.snp.makeConstraints {
      $0.trailing.leading.top.equalToSuperview()
      $0.width.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.55)
    }
    
    scrollView.addSubview(mainView)
    
    mainView.snp.makeConstraints {
      $0.top.equalTo(self.pageViewController.view.snp.bottom).inset(-16)
      $0.trailing.leading.bottom.equalToSuperview().inset(16)
    }
  }
}

extension DetailViewController {
  private func bind() {
    viewModel
      .productInfomation
      .observe(on: MainScheduler.instance)
      .subscribe { [weak self] in
        self?.mainView.setContent(content: $0)
      }
      .disposed(by: bag)
  }
}
