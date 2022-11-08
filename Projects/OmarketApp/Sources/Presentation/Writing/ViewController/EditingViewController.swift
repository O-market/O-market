//
//  EditingViewController.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/11/07.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import RxSwift
import SnapKit

final class EditingViewController: UIViewController {
  
  // MARK: Interfaces
  
  private let doneButton = UIBarButtonItem(
    title: "완료",
    style: .done,
    target: nil,
    action: nil
  )
  private let mainView = WritingView()
  
  // MARK: Properties
  
  weak var coordinator: EditingCoordinator?
  private let disposeBag = DisposeBag()
  private let viewModel: EditingViewModelable
  
  // MARK: Life Cycle

  init(viewModel: EditingViewModelable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind(viewModel: viewModel)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    coordinator?.removeCoordinator()
  }
  
  // MARK: Methods
  
  private func setViewItem(_ item: EditingViewModelItem) {
    mainView.titleTextField.text = item.title
    mainView.bodyTextView.text = item.body
    mainView.priceTextField.text = item.price
    mainView.discountPriceTextField.text = item.discountPrice
    mainView.stockTextField.text = item.stock
    
    item.imageURL.forEach {
      let imageView = ImageView(imageURL: $0)
      imageView.removeButton.isHidden = true
      mainView.addImageView([imageView])
    }
  }
  
  // MARK: Helpers
  
  private func bind(viewModel: EditingViewModelable) {
    viewModel.viewItem
      .bind { [weak self] in
        self?.setViewItem($0)
      }.disposed(by: disposeBag)
    
    doneButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        viewModel.doneButtonDidTap()
          .observe(on: MainScheduler.instance)
          .subscribe { _ in
            self.navigationController?.popViewController(animated: true)
          } onError: { error in
            let alert = UIAlertController
              .makeAlert(message: error.localizedDescription)
            self.present(alert, animated: true)
          }.disposed(by: self.disposeBag)
      }.disposed(by: disposeBag)
    
    mainView.titleTextField.rx.text
      .bind {
        viewModel.inputTitle($0)
      }.disposed(by: disposeBag)
    
    mainView.bodyTextView.rx.text
      .bind {
        viewModel.inputBody($0)
      }.disposed(by: disposeBag)
    
    mainView.bodyTextView.rx.text
      .orEmpty
      .map { !$0.isEmpty }
      .distinctUntilChanged()
      .bind(to: mainView.placeholderLabel.rx.isHidden)
      .disposed(by: disposeBag)
    
    mainView.priceTextField.rx.text
      .bind {
        viewModel.inputPirce($0)
      }.disposed(by: disposeBag)
    
    mainView.discountPriceTextField.rx.text
      .bind {
        viewModel.inputDiscountPrice($0)
      }.disposed(by: disposeBag)
    
    mainView.stockTextField.rx.text
      .bind {
        viewModel.inputStock($0)
      }.disposed(by: disposeBag)
  }
}

// MARK: - UI

extension EditingViewController {
  private func configureUI() {
    title = "제품 수정"
    navigationItem.rightBarButtonItem = doneButton
    doneButton.tintColor = ODS.Color.brand010
    view.backgroundColor = .systemBackground
    view.addSubview(mainView)
    mainView.buttonbackgarundView.isHidden = true
    mainView.snp.makeConstraints {
      $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
