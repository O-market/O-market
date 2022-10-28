//
//  MSImagePicker.swift
//  OmarketApp
//
//  Created by 이시원 on 2022/10/25.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Photos
import UIKit

import SnapKit

final class MSImagePicker: UIViewController {
  weak var delegate: MSImagePickerDelegate?
  private var fetchResult: PHFetchResult<PHAsset>?
  private let imageManager: PHCachingImageManager = .init()
  private let mainView = MSImagePickerView()
  let settings = MSPickerSettings()
  private var selectedItems = [MSAssetItem]() {
    didSet {
      mainView.setSelectionCount(selectedItems.count)
      mainView.addButton.isEnabled = selectedItems.count != 0
    }
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    mainView.photoCollectionView.dataSource = self
    mainView.photoCollectionView.delegate = self
    mainView.addButton.action = #selector(addButtomDidTap)
    mainView.cancelButton.action = #selector(cancelButtomDidTap)
    PHPhotoLibrary.shared().register(self)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    permissionCheck()
  }
  
  private func permissionCheck() {
    let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    switch photoAuthorizationStatus {
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization(
        for: .readWrite
      ) { [weak self] status in
        switch status {
        case .authorized:
          self?.requestCollection()
          DispatchQueue.main.async {
            self?.mainView.photoCollectionView.reloadData()
          }
        default:
          break
        }
      }
    case .authorized, .limited:
      requestCollection()
      mainView.photoCollectionView.reloadData()
    default:
      return
    }
  }
  
  private func requestCollection() {
    let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection
      .fetchAssetCollections(
        with: .smartAlbum,
        subtype: .smartAlbumUserLibrary,
        options: nil
      )
    
    guard let cameraRollCollection = cameraRoll.firstObject else { return }
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [
      NSSortDescriptor(
        key: "creationDate",
        ascending: false
      )
    ]
    fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
  }
  
  @objc
  private func addButtomDidTap() {
    let assetManagers = selectedItems.map { $0.imageManager }
    self.delegate?.picker(picker: self, results: assetManagers)
  }
  
  @objc
  private func cancelButtomDidTap() {
    delegate?.picker(picker: self, results: [])
  }
}

// MARK: - UI

extension MSImagePicker {
  private func configureUI() {
    view.backgroundColor = .systemBackground
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension MSImagePicker {
  private func isInselectionPool(indexPath: IndexPath) -> Bool {
    return selectedItems.contains {
      $0.assetIdentifier == fetchResult?.object(at: indexPath.row).localIdentifier
    }
  }
  
  private func deSelect(indexPath: IndexPath) {
    if let positionIndex = selectedItems.firstIndex(where: {
      $0.assetIdentifier == fetchResult?.object(at: indexPath.row).localIdentifier
    }) {
      selectedItems.remove(at: positionIndex)
      
      let selectedIndexPaths = selectedItems.map {
        IndexPath(row: $0.index, section: 0)
      }
      mainView.photoCollectionView.reloadItems(at: selectedIndexPaths + [indexPath])
    }
  }
  
  private func addToSelection(indexPath: IndexPath) {
    guard let asset = fetchResult?.object(at: indexPath.row) else { return }
    let newSelectionItem = MSAssetItem(
      index: indexPath.row,
      assetIdentifier: asset.localIdentifier,
      assetManager: .init(asset: asset)
    )
    if let selectionLimit = settings.selectionLimit {
      if selectionLimit > selectedItems.count {
        selectedItems.append(newSelectionItem)
      } else {
        showAlert()
      }
    } else {
      selectedItems.append(newSelectionItem)
    }
    mainView.photoCollectionView.reloadItems(at: [indexPath])
  }
}

// MARK: - Alert

extension MSImagePicker {
  private func showAlert() {
    guard let selectionLimit = settings.selectionLimit else { return }
    let alert = UIAlertController(
      title: nil,
      message: "이미지는 최대 \(selectionLimit)장까지 첨부할 수 있습니다.",
      preferredStyle: .alert
    )
    let okAction = UIAlertAction(title: "확인", style: .default)
    alert.addAction(okAction)
    present(alert, animated: true)
  }
}


// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension MSImagePicker: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return fetchResult?.count ?? 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = mainView.photoCollectionView.dequeueReusableCell(
      withReuseIdentifier: MSImageCell.identifier,
      for: indexPath
    ) as? MSImageCell ?? MSImageCell()
    
    guard let asset = fetchResult?.object(at: indexPath.row) else { return cell }
    cell.representedAssetIdentifier = asset.localIdentifier
    cell.selectionIndicator.circleColor = settings.selectedIndicatorColor
    
    imageManager.requestImage(
      for: asset,
      targetSize: cell.bounds.size,
      contentMode: .aspectFill,
      options: nil
    ) { image, _ in
      if cell.representedAssetIdentifier == asset.localIdentifier && image != nil {
        cell.imageView.image = image
      }
    }
    
    if let index = selectedItems.firstIndex(
      where: { $0.assetIdentifier == asset.localIdentifier }
    ) {
      cell.selectionIndicator.setNumber(index + 1)
    } else {
      cell.selectionIndicator.setNumber(nil)
    }
    
    return cell
  }
}

extension MSImagePicker: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    
    let cellIsInTheSelectionPool = isInselectionPool(indexPath: indexPath)

    if cellIsInTheSelectionPool {
      deSelect(indexPath: indexPath)
    } else {
      addToSelection(indexPath: indexPath)
    }
  }
}

extension MSImagePicker: PHPhotoLibraryChangeObserver {
  func photoLibraryDidChange(_ changeInstance: PHChange) {
    self.requestCollection()
    DispatchQueue.main.async {
      self.mainView.photoCollectionView.reloadData()
    }
  }
}
