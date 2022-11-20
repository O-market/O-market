//
//  CreationViewController.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/18.
//  Copyright © 2022 Omarket. All rights reserved.
//

import UIKit

import ODesignSystem
import RxSwift
import SnapKit

class CreationViewController: UIViewController {
  weak var coordinator: CreationCoordinator?
  private let disposeBag = DisposeBag()
  private let doneButton = UIBarButtonItem(
    title: "완료",
    style: .done,
    target: nil,
    action: nil
  )
  private let mainView = WritingView()
  private let viewModel: CreationViewModelable
  
  init(viewModel: CreationViewModelable) {
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

extension CreationViewController {
  private func configureUI() {
    title = "글쓰기"
    navigationItem.rightBarButtonItem = doneButton
    doneButton.tintColor = ODS.Color.brand010
    view.backgroundColor = .systemBackground
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

// MARK: - Extension

extension CreationViewController {
  private func bind() {
    mainView.bodyTextView.rx.text
      .orEmpty
      .map { !$0.isEmpty }
      .distinctUntilChanged()
      .bind(to: mainView.placeholderLabel.rx.isHidden)
      .disposed(by: disposeBag)
    
    mainView.photoButton.rx.tap
      .bind { [weak self] in
        self?.presentImagePicker()
      }.disposed(by: disposeBag)
    
    viewModel.numberOfImagesSelected
      .bind { [weak self] in
        guard let self = self else { return }
        self.mainView.photoButton.imageCountLabel.text = "\($0)/\(self.viewModel.imageCountMax)"
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
      description: self.mainView.bodyTextView.text,
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

// MARK: - SFImagePicker

extension CreationViewController {
  private func presentImagePicker() {
    coordinator?.presentImagePicker(
      selectionMin: viewModel.imageCountMin,
      selectionMax: viewModel.selectionLimit,
      onSelected: { imageManager in
        imageManager.request(
          size: CGSize(width: 100, height: 100)
        ) { [weak self] image, _ in
          guard let pngData = image?.pngData() else { return }
          let imageData = ImageData(id: imageManager.assetID, data: pngData)
          self?.viewModel.selectedImageData(imageData)
          if let imageView = self?.mainView.searchImageView(
            id: imageManager.assetID.uuidString
          ) {
            imageView.image = image
          } else {
            self?.addImage(image, id: imageManager.assetID)
          }
        }
      },
      onDeSelcted: { [weak self] imageManager in
        let imageView = self?.mainView.searchImageView(id: imageManager.assetID.uuidString)
        imageView?.removeButtonDidTap()
      },
      onCanceled: { [weak self] imageManagers in
        imageManagers.forEach { imageManager in
          let imageView = self?.mainView.searchImageView(id: imageManager.assetID.uuidString)
          imageView?.removeButtonDidTap()
        }
      }
    )
  }
  
  private func addImage(_ image: UIImage?, id: UUID) {
    guard let image = image else { return }
    let imageView = ProductImageView(image: image)
    imageView.identifier = id.uuidString
    imageView.removeAction = { [weak self] in
      self?.viewModel.removeImageData(id: id)
    }
    mainView.addImageView(imageView)
  }
}
