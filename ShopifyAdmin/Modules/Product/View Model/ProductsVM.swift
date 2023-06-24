//
//  ProductsVM.swift
//
//  Created by Moaz Khaled on 06/06/2023.
//

import Foundation
class ProductsVM {
    
    var bindResultToDisplayProducts: (( ) -> Void)?
    
    var allProducts : ProductsResponse!{
        didSet{
            bindResultToDisplayProducts?()
            
        }
    }
    
    func getAllProducts (){
        Network.get(endPoint: EndPoints.createProduct ) { [weak self] (data : ProductsResponse? , error ) in
            guard let data = data else{ return}
            self?.allProducts = data
      //      print(data)
        }
    }
    
    func deleteProduct(productId: Int){
        Network.delete(endPoint: EndPoints.updateProduct(id: productId))
    }
}
