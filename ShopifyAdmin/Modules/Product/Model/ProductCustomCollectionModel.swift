//
//  ProductCustomCollectionModel.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 06/06/2023.
//

import Foundation
struct ProductCustomCollectionModel: Codable {
    let collect: CustomCollection
}

// MARK: - Collect
struct CustomCollection: Codable {
    let id, collection_id, product_id: Int
    let position: Int
    let sort_value: String

   
}
