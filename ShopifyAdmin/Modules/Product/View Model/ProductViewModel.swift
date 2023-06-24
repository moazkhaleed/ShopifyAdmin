//
//  ProductViewModel.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 06/06/2023.
//

import Foundation
import Alamofire

class ProductViewModel{
    
    var bindResultToProduct: (() -> ()) = {}
//    var bindImg: (() -> ()) = {}
    var bindProductCustomCollection: (() -> ()) = {}
    
    var newProduct : ProductInfoResponse!{
        didSet{
            bindResultToProduct()
        }
    }
    
//    var productImg : ProductImgModel!{
//        didSet{
//            bindImg()
//        }
//    }

    var productCustomCollection : ProductCustomCollectionModel!{
        didSet{
            bindProductCustomCollection()
        }
    }
    
    func createProduct(product:Product){
        let params : Parameters = Utils.encodeToJson(objectClass:ProductInfoResponse(product: product))!
        Network.post(endPoint: EndPoints.createProduct, params: params) { [weak self] (data: ProductInfoResponse?, error) in
            guard let responsData = data else{ return}
            self?.newProduct = responsData
        }
    }
    
    func createProductImg(params: [String: Any], id: Int){
        Network.post(endPoint: EndPoints.createProductImg(id: id), params: params) { (data: ProductImgModel?, error) in
            //            guard let responsData = data else{ return}
            //            self?.productImg = responsData
            //            print(responsData.image.src)
        }
    }
    
    func addProdoctCustomCollection(params: [String: Any]){
        Network.post(endPoint: EndPoints.addProductToCustomCollection, params: params) {(data: ProductCustomCollectionModel?, error) in
            guard let responsData = data else{ return}
            self.productCustomCollection = responsData
            print(self.productCustomCollection.collect.collection_id)
            
        }
    }
    
//    func editProduct(params: [String: Any], id: Int){
//        Network.update(endPoint: EndPoints.updateProduct(id: id), params: params) {(data: ProductInfo?, error) in
//            guard let responsData = data else{ return}
//
//            print(responsData.product?.title)
//        }
//    }
    
    func editProduct(product:Product){
        let params : Parameters = Utils.encodeToJson(objectClass:ProductInfoResponse(product: product))!
        
        Network.update(endPoint: EndPoints.updateProduct(id: product.id!), params: params) { [weak self] (data: ProductInfoResponse?, error) in
            guard let responsData = data else{ return}
            self?.newProduct = responsData
        }
    }
    
    
    func updateVariants(product: Product){
        for variant in product.variants!{
            if variant.id != nil {
                let inventoryLevel = InventoryLevel(inventoryItemId: variant.inventoryItemId, locationId: Int(Constants.location), available: variant.inventoryQuantity
                )
                let params : Parameters = Utils.encodeToJson(objectClass:InventoryLevelResponse(inventoryLevel:inventoryLevel))!
                
                Network.post(endPoint: EndPoints.inventorySet, params: params) { [weak self] (data: InventoryLevelResponse?, error) in
                    guard let responsData = data else{ return}
                    
                    print(responsData.inventoryLevel?.locationId)
                }
                
            }
        }
    }
}
