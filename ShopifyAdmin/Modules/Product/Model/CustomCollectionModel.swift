//
//  CustomCollectionModel.swift
//  ShopifyAdmin
//
//  Created by Moaz on 11/06/2023.
//

import Foundation

struct CustomCollectionModel: Codable {
    let custom_collection: NewCustomCollection
 
}

struct AllCustomCollectionModel: Codable {
    let custom_collections: [NewCustomCollection]
 
}
 

struct NewCustomCollection: Codable {
    let id: Int
    let title: String
     
}
