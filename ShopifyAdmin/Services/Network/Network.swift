//
//  Network.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 06/06/2023.
//

import Foundation
import Alamofire

private let BASE_URL = "https://3c83d9abc134ed858ac39489d33e5378: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@mad43-sv-ios2.myshopify.com/admin/api/2023-04/"

class Network : NetworkProtocol{
    
    static func get<T>(endPoint: EndPoints, completionHandeler: @escaping ((T?), Error?) -> Void) where T : Decodable {
        
        let path = "\(BASE_URL)\(endPoint.path)"

        Alamofire.request(path).responseJSON { response in
            do{
                guard let responseData = response.data else{return}
                let result = try JSONDecoder().decode(T.self, from: responseData)
                                
                completionHandeler(result, nil)
                
            }catch let error
            {
                completionHandeler(nil, error)
                print(error.localizedDescription)
            }
        }
        
    }
    
    static func post<T:Codable>(endPoint: EndPoints, params: [String : Any], completionHandeler: @escaping ((T?), Error?) -> Void) where T : Decodable, T : Encodable {
        
        let path = "\(BASE_URL)\(endPoint.path)"
        let url = URL(string: path)
        guard let url = url else{ return }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpShouldHandleCookies = false

        do{
            let requestBody = try JSONSerialization.data(withJSONObject: params,options: .prettyPrinted)
            request.httpBody = requestBody
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")

        }catch let error{
            debugPrint(error.localizedDescription)
        }

        Alamofire.request(request).responseJSON { response in
            
            do{
                guard let jsonObject = try JSONSerialization.jsonObject(with: response.data!) as? [String: Any] else {
                   print("Error: Cannot convert data to JSON object")
                   return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                   print("Error: Cannot convert JSON object to Pretty JSON data")
                   return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                   print("Error: Could print JSON in String")
                   return
                }
                print(prettyPrintedJson)
                print("-------------------------")
                
                
                guard let responseData = response.data else{return}
                print("responseData: \(responseData)")
                print("-------------------------")
                let result = try JSONDecoder().decode(T.self, from: responseData)

                completionHandeler(result, nil)

            }catch let error
            {
                completionHandeler(nil, error)
                print(error.localizedDescription)
            }
        }
        
    }
    
    static func update<T>(endPoint: EndPoints, params: [String : Any], completionHandeler: @escaping ((T?), Error?) -> Void) where T : Decodable, T : Encodable {
        
        let path = "\(BASE_URL)\(endPoint.path)"
        let url = URL(string: path)
        guard let url = url else{ return }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        request.httpShouldHandleCookies = false

        do{
            let requestBody = try JSONSerialization.data(withJSONObject: params,options: .prettyPrinted)
            request.httpBody = requestBody
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")

        }catch let error{
            debugPrint(error.localizedDescription)
        }

        Alamofire.request(request).responseJSON { response in
            do{
                guard let responseData = response.data else{return}
                let result = try JSONDecoder().decode(T.self, from: responseData)
                                
                completionHandeler(result, nil)
                
            }catch let error
            {
                completionHandeler(nil, error)
                print(error.localizedDescription)
            }
        }
        
    }
    
    static func delete(endPoint: EndPoints) {
        let path = "\(BASE_URL)\(endPoint.path)"

        let headers: HTTPHeaders = ["content-type": "Application/json"]
        
        Alamofire.request(path,method: .delete,headers: headers).responseJSON { response in
            guard let responseData = response.data else{return}
            print(responseData)
        }
    }
    
}
