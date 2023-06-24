//
//  CollectionsViewModel.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 10/06/2023.
//

import Foundation

class CollectionsViewModel {
    
    var bindResultToDisplayBrands: (( ) -> Void)?
    
    var bindCustomCollection: (() -> ()) = {}
    
    var allBrands : AllSmartCollectionModel!{
        didSet{
            bindResultToDisplayBrands?()
            
        }
    }
    
    var allCustomCollection : AllCustomCollectionModel!{
        didSet{
            bindCustomCollection()
        }
    }
    
    func getAllBrands(){
        Network.get(endPoint: EndPoints.createSmartCollection) { [weak self] (data : AllSmartCollectionModel? , error ) in
            guard let data = data else{ return}
            self?.allBrands = data
            print("data")
            print(data.smart_collections.count)
        }
    }
    
    func getAllCustomCollection(){
        Network.get(endPoint: EndPoints.createCustomCollection) { [weak self] (data : AllCustomCollectionModel? , error ) in
            guard let data = data else{ return}
            self?.allCustomCollection = data
//            print(data)
        }
    }
    
    func deleteFromSmartCollection(smartCollectionId: Int){
        Network.delete(endPoint: EndPoints.editSmartCollection(id: smartCollectionId))
    }
    
    func deleteFromCustomCollection(customCollectionId: Int){
        Network.delete(endPoint: EndPoints.editCustomCollection(id: customCollectionId))
    }
    
}
