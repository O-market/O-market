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
  
  // MARK: Interfaces
  
  private let doneButton = UIBarButtonItem(
    title: "완료",
    style: .done,
    target: nil,
    action: nil
  )
  private let mainView = WritingView()
  
  // MARK: Properties
  
  weak var coordinator: CreationCoordinator?
  private let disposeBag = DisposeBag()
  private let viewModel: CreationViewModelable
  
  // MARK: Life Cycle
  
  init(viewModel: CreationViewModelable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    coordinator?.removeCoordinator()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind(viewModel: viewModel)
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

// MARK: Methods

// MARK: Helpers

extension CreationViewController {
  private func bind(viewModel: CreationViewModelable) {
    mainView.bodyTextView.rx.text
      .orEmpty
      .map { !$0.isEmpty }
      .distinctUntilChanged()
      .bind(to: mainView.placeholderLabel.rx.isHidden)
      .disposed(by: disposeBag)
    
    mainView.photoButton.rx.tap
      .bind(onNext: presentImagePicker)
      .disposed(by: disposeBag)
    
    viewModel.numberOfImagesSelected
      .bind(to: mainView.photoButton.imageCountLabel.rx.text)
      .disposed(by: disposeBag)
    
    doneButton.rx.tap
      .withUnretained(mainView)
      .flatMap { owner, _ in owner.printEmptyTextField() }
      .bind(onNext: viewModel.doneButtonDidTap)
      .disposed(by: disposeBag)
    
    viewModel.printErrorMessage
      .bind(onNext: showErrorAlert)
      .disposed(by: disposeBag)
    
    viewModel.requestCreation
      .observe(on: MainScheduler.instance)
      .subscribe(
        onNext: finishCreation,
        onError: viewModel.postErrorMessage
      ).disposed(by: disposeBag)
  }
  
  private func showErrorAlert(message: String) {
    let alert = UIAlertController.makeAlert(message: message)
    self.present(alert, animated: true)
  }
  
  private func finishCreation() {
    NotificationCenter.default.post(name: .productsDidRenew, object: nil)
    self.navigationController?.popViewController(animated: true)
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
