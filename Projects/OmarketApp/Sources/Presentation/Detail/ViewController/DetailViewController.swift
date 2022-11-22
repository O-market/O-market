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
      .withUnretained(self)
      .flatMap { owner, _ in owner.showEditingAlert() }
      .bind(onNext: viewModel.selectEditAlertAction)
      .disposed(by: disposeBag)
    
    viewModel.editAction
      .bind(onNext: showEditingView)
      .disposed(by: disposeBag)
    
    viewModel.deleteAction
      .withUnretained(self)
      .flatMap { owner, _ in owner.showDeletionAlert() }
      .bind(onNext: viewModel.selectDeleteAlertAction)
      .disposed(by: disposeBag)
    
    viewModel.deleteButtonDidTap()
      .observe(on: MainScheduler.instance)
      .subscribe(
        onNext: finishDeletion,
        onError: showErrorAlert
      ).disposed(by: disposeBag)
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
  private func showEditingAlert() -> Observable<String> {
    return Single.create { [weak self] single in
      let alert = UIAlertController(
        title: nil,
        message: nil,
        preferredStyle: .actionSheet
      )
      let editAction = UIAlertAction(title: "수정", style: .default) { _ in
        single(.success("수정"))
      }
      let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
        single(.success("삭제"))
      }
      let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
        single(.success("취소"))
      }
      [editAction, deleteAction, cancelAction].forEach { action in
        alert.addAction(action)
      }
      self?.present(alert, animated: true)
      return Disposables.create {
        alert.dismiss(animated: true)
      }
    }.asObservable()
  }
  
  private func showDeletionAlert() -> Observable<String> {
    return Single.create { [weak self] single in
      let alert = UIAlertController(
        title: nil,
        message: "게시글을 정말 삭제하시겠어요?",
        preferredStyle: .alert
      )
      ["삭제", "취소"].forEach { title in
        let action = UIAlertAction(
          title: title,
          style: title == "삭제" ? .destructive : .cancel
        ) { _ in
          single(.success(title))
        }
        alert.addAction(action)
      }
      self?.present(alert, animated: true)
      return Disposables.create {
        alert.dismiss(animated: true)
      }
    }.asObservable()
  }
  
  private func showEditingView() {
    guard let product = viewModel.product else { return }
    self.coordinator?.showEditingView(product: product)
  }
  
  private func finishDeletion() {
    NotificationCenter.default.post(name: .productsDidRenew, object: nil)
    self.navigationController?.popViewController(animated: true)
  }
  
  private func showErrorAlert(error: Error) {
    let alert = UIAlertController.makeAlert(message: error.localizedDescription)
    self.present(alert, animated: true)
  }
}
