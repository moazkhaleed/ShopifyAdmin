//
//  DiscountsViewModel.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 19/06/2023.
//

import Foundation

class DiscountsViewModel{
    
    func getAllDiscountCoupons(priceRule:PriceRule, completionHandler: @escaping ([DiscountCode]) -> Void){

        Network.get(endPoint: EndPoints.discountCodes(id: priceRule.id ?? 0)) {(data: DiscountCodesResponse?, error) in
            guard let responsData = data else{ return}
            completionHandler(responsData.discountCodes)
        }
        
    }
    
    func addDiscountCode(discountCode:DiscountCode ,priceRule:PriceRule, completionHandler: @escaping (DiscountCode) -> Void){
        
        let params: [String: Any] = [
            "discount_code":[
                "code": discountCode.code
                ]
        ]
        
        Network.post(endPoint: EndPoints.discountCodes(id: priceRule.id ?? 0), params: params) {(data: CouponDiscountCodeModel?, error) in
            guard let responsData = data else{ return}
            completionHandler(responsData.discountCode)
          //  print(responsData.discount_code.code ?? "")
        }
    }
    
    func updateDiscountCode(discountCode:DiscountCode ,priceRule:PriceRule, completionHandler: @escaping (DiscountCode) -> Void){
        
        let params: [String: Any] = [
            "discount_code":[
                "id": discountCode.id,
                "code": discountCode.code
                ]
        ]
                
        Network.update(endPoint: EndPoints.singleDiscountCode(priceRuleId: priceRule.id ?? 0, discountId: discountCode.id ?? 0), params: params) {(data: CouponDiscountCodeModel?, error) in
            guard let responsData = data else{ return}
            completionHandler(responsData.discountCode)
          //  print(responsData.discount_code.code ?? "responsData.discount_code")
        }
        
        
    }
    
    func deleteDiscountCode(discountCode:DiscountCode ,priceRule:PriceRule){
        
        Network.delete(endPoint: EndPoints.singleDiscountCode(priceRuleId: priceRule.id ?? 0, discountId: discountCode.id ?? 0))
    }
}
