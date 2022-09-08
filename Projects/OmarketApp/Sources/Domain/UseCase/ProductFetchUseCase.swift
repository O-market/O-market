//
//  ProductFetchUseCase.swift
//  OmarketApp
//
//  Created by Lingo on 2022/08/23.
//  Copyright © 2022 Omarket. All rights reserved.
//

import Foundation

import RxSwift

struct ProductRequestQuery {
  let pageNumber: Int
  let itemsPerPage: Int
}

protocol ProductFetchUseCase {
  func fetchAll(query: ProductRequestQuery) -> Observable<[Product]>
  func fetchOne(id: Int) -> Observable<Product>
  func createProduct(product: Product, images: [Data]) -> Observable<Void>
}

final class ProductFetchUseCaseImpl: ProductFetchUseCase {
  private let repository: ProductRepository

  init(repository: ProductRepository) {
    self.repository = repository
  }

  func fetchAll(query: ProductRequestQuery) -> Observable<[Product]> {
    let endpoint = EndpointAPI.products(query).asEndpoint
    return repository.fetchAllProduct(endpoint: endpoint)
  }

  func fetchOne(id: Int) -> Observable<Product> {
    let endpoint = EndpointAPI.product(id).asEndpoint
    return repository.fetchProduct(endpoint: endpoint)
  }
  
  func createProduct(product: Product, images: [Data]) -> Observable<Void> {
    let boundary = UUID().uuidString
    let formData = makeFormData(product: product)
    let imageFormDatas = makeImageFormDatas(images: images)
    let payload = FormDataBuilder
      .create(token: boundary)
      .append(formData)
      .append(imageFormDatas)
      .apply()
    let endpoint = EndpointAPI.productCreation(payload, boundary).asEndpoint
    return repository.createProduct(endpoint: endpoint)
  }
}

// MARK: - Extension

extension ProductFetchUseCaseImpl {
  private func makeFormData(product: Product) -> FormData {
    return FormData(
      type: .json,
      name: "params",
      data: try? JSONEncoder().encode(makeProductRequest(product: product))
    )
  }
  
  private func makeProductRequest(product: Product) -> ProductRequest {
    return ProductRequest(
      name: product.name,
      description: product.description,
      price: product.price,
      currency: product.currency,
      discountedPrice: product.discountedPrice,
      stock: product.stock,
      vendorSecretKey: UserInformation.password
    )
  }
  
  private func makeImageFormDatas(images: [Data]) -> [FormData] {
    return images.map { imageData in
      FormData(
        type: .jpeg,
        name: "images",
        filename: "images.jpeg",
        data: imageData
      )
    }
  }
}
