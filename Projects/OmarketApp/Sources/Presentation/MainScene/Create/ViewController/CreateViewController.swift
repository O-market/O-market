//
//  CreateViewController.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/18.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import RxSwift
import SnapKit

class CreateViewController: UIViewController {
  weak var coordinator: CreateCoordinator?
  private let disposeBag = DisposeBag()
  private let doneButton = UIBarButtonItem(
    title: "완료",
    style: .done,
    target: nil,
    action: nil
  )
  private let mainView = WritingView()
  private let viewModel: CreateViewModelable
  
  init(viewModel: CreateViewModelable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    coordinator?.removeCoordinator()
  }
}

// MARK: - UI

extension CreateViewController {
  private func configureUI() {
    title = "글쓰기"
    navigationItem.rightBarButtonItem = doneButton
    doneButton.tintColor = ODS.Color.example
    view.backgroundColor = .systemBackground
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

// MARK: - Extension

extension CreateViewController {
  private func bind() {
    mainView.textView.rx.text
      .orEmpty
      .map { !$0.isEmpty }
      .distinctUntilChanged()
      .bind(to: mainView.placeholderLabel.rx.isHidden)
      .disposed(by: disposeBag)
    
    mainView.photoButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.coordinator?.presentImagePicker(
          limitCount: self.viewModel.selectionLimit,
          delegate: self
        )
      }.disposed(by: disposeBag)
    
    viewModel.numberOfImagesSelected
      .bind { [weak self] in
        guard let self = self else { return }
        self.mainView.photoButton.imageCountLabel.text = "\($0)/\(self.viewModel.imageCountLimit)"
      }
      .disposed(by: disposeBag)
    
    doneButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        if let textFields = self.mainView.checkEmptyTextField() {
          let alert = UIAlertController.makeAlert(message: "\(textFields)은 필수 입력 항목입니다.")
          self.present(alert, animated: true)
        } else {
          self.viewModel.doneButtonDidTap(
            product: self.makeProduct()
          )
          .observe(on: MainScheduler.instance)
          .subscribe(onNext: {
            self.navigationController?.popViewController(animated: true)
          }, onError: {
            let alert = UIAlertController.makeAlert(message: $0.localizedDescription)
            self.present(alert, animated: true)
          }).disposed(by: self.disposeBag)
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func makeProduct() -> Product {
    return Product(
      id: 0,
      vendorId: 0,
      name: self.mainView.titleTextField.text ?? "",
      description: self.mainView.textView.text,
      thumbnail: "",
      currency: "KRW",
      price: Double(self.mainView.priceTextField.text ?? "") ?? 0.0,
      bargainPrice: 0.0,
      discountedPrice: Double(self.mainView.discountPriceTextField.text ?? "") ?? 0.0,
      stock: Int(self.mainView.stockTextField.text ?? "") ?? 0,
      createdAt: "",
      issuedAt: ""
    )
  }
}

// MARK: - MSImagePickerDelegate

extension CreateViewController: MSImagePickerDelegate {
  func picker(picker: UIViewController, results: [MSImageManager]) {
    picker.dismiss(animated: true)
    results.forEach {
      $0.request(
        size: CGSize(width: 100, height: 100)
      ) { [weak self] image in
        guard let image = image else { return }
        guard let pngData = image.pngData() else { return }
        let imageData = ImageData(data: pngData)
        let imageView = ImageView(image: image)
        imageView.removeAction = { [weak self] in
          self?.viewModel.removeImageData(id: imageData.id)
        }
        self?.mainView.addImageView([imageView])
        self?.viewModel.selectedImageData([imageData])
      }
    }
  }
}
