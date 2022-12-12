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
  
  deinit {
    coordinator?.removeCoordinator()
    print("ss")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind(viewModel: viewModel)
  }
  
  // MARK: Methods
  
  // MARK: Helpers
  
  private func bind(viewModel: EditingViewModelable) {
    viewModel.viewItem
      .bind(to: setViewItem)
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
    
    viewModel.requestEditing
      .observe(on: MainScheduler.instance)
      .bind(to: finishEditing)
      .disposed(by: disposeBag)
    
    viewModel.printErrorMessage
      .bind(to: showErrorAlert)
      .disposed(by: disposeBag)
  }
  
  private var finishEditing: Binder<Void> {
    return Binder(self) { owner, _ in
      NotificationCenter.default.post(name: .productsDidRenew, object: nil)
      owner.navigationController?.popViewController(animated: true)
    }
  }
  
  private var showErrorAlert: Binder<String> {
    return Binder(self) { owner, message in
      let alert = UIAlertController.makeAlert(message: message)
      owner.present(alert, animated: true)
    }
  }
  
  private var setViewItem: Binder<EditingViewModelItem> {
    return Binder(self.mainView) { view, item in
      view.titleTextField.text = item.title
      view.bodyTextView.text = item.body
      view.priceTextField.text = item.price
      view.discountPriceTextField.text = item.discountPrice
      view.stockTextField.text = item.stock
      
      item.imageURL.forEach {
        let imageView = ProductImageView(imageURL: $0)
        imageView.removeButton.isHidden = true
        view.addImageView(imageView)
      }
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
