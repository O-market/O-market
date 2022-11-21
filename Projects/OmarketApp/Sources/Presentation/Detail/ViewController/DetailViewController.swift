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
  
  // MARK: Interfaces
  
  private let mainView = DetailView(frame: .zero)
  private let editBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"))
  
  // MARK: Properties
  
  private let viewModel: DetailViewModelable
  private let disposeBag = DisposeBag()
  weak var coordinator: DetailCoordinator?
  
  // MARK: Life Cycle
  
  init(viewModel: DetailViewModelable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind(viewModel: viewModel)
    configureUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    viewModel.fetchProductDetail()
  }
  
  deinit {
    coordinator?.removeCoordinator()
  }
}

// MARK: - UI

extension DetailViewController {
  private func configureUI() {
    title = "상품상세"
    view.backgroundColor = .systemBackground
    view.addSubview(mainView)
    
    mainView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
}

// MARK: Methods

// MARK: Helpers

extension DetailViewController {
  private func bind(viewModel: DetailViewModelable) {
    bindButton(viewModel: viewModel)
    bindUI(viewModel: viewModel)
  }
  
  private func bindButton(viewModel: DetailViewModelable) {
    editBarButton.rx.tap
      .bind { [weak self] in
        let alert = UIAlertController(
          title: nil,
          message: nil,
          preferredStyle: UIAlertController.Style.actionSheet
        )
        let editAction = UIAlertAction(title: "수정", style: .default) {_ in
          guard let product = viewModel.product else { return }
          self?.coordinator?.showEditingView(product: product)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) {_ in
          self?.showDeleteAlert(viewModel: viewModel)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [editAction, deleteAction, cancelAction].forEach {
          alert.addAction($0)
        }
        self?.present(alert, animated: true)
      }.disposed(by: disposeBag)
  }
  
  private func bindUI(viewModel: DetailViewModelable) {
    viewModel.isMyProduct
      .filter { $0 }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] _ in
        if self?.navigationItem.rightBarButtonItem == nil {
          self?.navigationItem.setRightBarButton(self?.editBarButton, animated: true)
        }
      }
      .disposed(by: disposeBag)
    
    viewModel
      .productImageURL
      .observe(on: MainScheduler.instance)
      .bind(to: mainView.imageCollectionView.rx.items(
        cellIdentifier: ProductImageCell.identifier,
        cellType: ProductImageCell.self)) { _, item, cell in
          cell.setImage(imageURL: item)
        }
        .disposed(by: disposeBag)
    
    viewModel
      .productInfomation
      .observe(on: MainScheduler.instance)
      .subscribe { [weak self] in
        self?.mainView.setContent(content: $0)
      }
      .disposed(by: disposeBag)
    
    viewModel
      .productImageCount
      .observe(on: MainScheduler.instance)
      .subscribe { [weak self] in
        self?.mainView.pageControl.numberOfPages = $0
      }
      .disposed(by: disposeBag)
  }
}

extension DetailViewController {
  private func showDeleteAlert(viewModel: DetailViewModelable) {
    let alert = UIAlertController(
      title: nil,
      message: "게시글을 정말 삭제하시겠어요?",
      preferredStyle: .alert
    )
    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
      guard let self = self else { return }
      viewModel.deleteButtonDidTap()
        .subscribe { _ in
          DispatchQueue.main.async {
            NotificationCenter.default.post(name: .productsDidRenew, object: nil)
            self.navigationController?.popViewController(animated: true)
          }
        } onError: { error in
          DispatchQueue.main.async {
            let alert = UIAlertController.makeAlert(message: error.localizedDescription)
            self.present(alert, animated: true)
          }
        }.disposed(by: self.disposeBag)
    }
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    
    [deleteAction, cancelAction].forEach { action in
      alert.addAction(action)
    }
    present(alert, animated: true)
  }
}
