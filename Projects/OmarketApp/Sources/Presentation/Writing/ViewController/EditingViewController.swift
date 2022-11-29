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
  
  // MARK: Helpers
  
  private func bind(viewModel: EditingViewModelable) {
    viewModel.viewItem
      .bind(onNext: setViewItem)
      .disposed(by: disposeBag)
    
    buttonBind(viewModel: viewModel)
    textFieldBind(viewModel: viewModel)
    textViewBind(viewModel: viewModel)
  }
  
  private func textFieldBind(viewModel: EditingViewModelable) {
    mainView.titleTextField.rx.text
      .bind(onNext: viewModel.inputTitle)
      .disposed(by: disposeBag)
    
    mainView.priceTextField.rx.text
      .bind(onNext: viewModel.inputPrice)
      .disposed(by: disposeBag)
    
    mainView.discountPriceTextField.rx.text
      .bind(onNext: viewModel.inputDiscountPrice)
      .disposed(by: disposeBag)
    
    mainView.stockTextField.rx.text
      .bind(onNext: viewModel.inputStock)
      .disposed(by: disposeBag)
  }
  
  private func textViewBind(viewModel: EditingViewModelable) {
    mainView.bodyTextView.rx.text
      .bind(onNext: viewModel.inputBody)
      .disposed(by: disposeBag)
    
    mainView.bodyTextView.rx.text
      .orEmpty
      .map { !$0.isEmpty }
      .distinctUntilChanged()
      .bind(to: mainView.placeholderLabel.rx.isHidden)
      .disposed(by: disposeBag)
  }
  
  private func buttonBind(viewModel: EditingViewModelable) {
    doneButton.rx.tap
      .bind(onNext: viewModel.doneButtonDidTap)
      .disposed(by: disposeBag)
    
    viewModel.doneButtonAction
      .observe(on: MainScheduler.instance)
      .subscribe(
        onNext: finishEditing,
        onError: showErrorAlert
      )
      .disposed(by: disposeBag)
  }
  
  private func finishEditing() {
    NotificationCenter.default.post(name: .productsDidRenew, object: nil)
    self.navigationController?.popViewController(animated: true)
  }
  
  private func showErrorAlert(_ error: Error) {
    let alert = UIAlertController.makeAlert(message: error.localizedDescription)
    self.present(alert, animated: true)
  }
  
  private func setViewItem(_ item: EditingViewModelItem) {
    mainView.titleTextField.text = item.title
    mainView.bodyTextView.text = item.body
    mainView.priceTextField.text = item.price
    mainView.discountPriceTextField.text = item.discountPrice
    mainView.stockTextField.text = item.stock
    
    item.imageURL.forEach {
      let imageView = ProductImageView(imageURL: $0)
      imageView.removeButton.isHidden = true
      mainView.addImageView(imageView)
    }
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
