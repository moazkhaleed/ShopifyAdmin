//
//  PriceRuleViewModel.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 19/06/2023.
//

import Foundation

class PriceRuleViewModel{
    
    var network:NetworkProtocol
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func getAllPriceRules(completionHandler: @escaping ([PriceRule]) -> Void){
        
        Network.get(endPoint: EndPoints.couponPriceRule) {(data: PriceRulesResponse?, error) in
            guard let responsData = data else{ return}
            completionHandler(responsData.price_rules )
        }
    }
    
    func addPriceRule(priceRule: PriceRule,completionHandler: @escaping (PriceRule) -> Void){
        
        let params: [String: Any] = [
            "price_rule":[
                "title": priceRule.title,
                "value_type": priceRule.valueType,
                "value": priceRule.value,

                "starts_at": priceRule.startsAt,
                "ends_at": priceRule.endsAt,
                "usage_limit": priceRule.usageLimit,
                "customer_selection": "all",
                "target_type": "line_item",
                "target_selection": "all",
                "allocation_method": "across"
            ] as [String : Any]
        ]
        
        Network.post(endPoint: EndPoints.couponPriceRule, params: params) { [weak self] (data: SinglePriceRuleResponse?, error) in
            guard let responsData = data else{ return}
            completionHandler((responsData.price_rule))
            print(responsData.price_rule ?? 0)
        }
    }

    func updatePriceRule(priceRule: PriceRule,completionHandler: @escaping (PriceRule) -> Void){
        
        let params: [String: Any] = [
            "price_rule":[
                "title": priceRule.title,
                "value_type": priceRule.valueType,
                "value": priceRule.value,

                "starts_at": priceRule.startsAt,
                "ends_at": priceRule.endsAt,
                "usage_limit": priceRule.usageLimit,
                "customer_selection": "all",
                "target_type": "line_item",
                "target_selection": "all",
                "allocation_method": "across"
            ] as [String : Any]
        ]
        Network.update(endPoint: EndPoints.editPriceRule(id: priceRule.id ?? 0), params: params) { [weak self] (data: SinglePriceRuleResponse?, error)  in
            guard let responsData = data else{ return}
            
            completionHandler(responsData.price_rule)
            
            print(responsData.price_rule)
        }
    }
    
    func deletePriceRule(priceRule: PriceRule){
        Network.delete(endPoint: EndPoints.editPriceRule(id: priceRule.id ?? 0))
    }
}
