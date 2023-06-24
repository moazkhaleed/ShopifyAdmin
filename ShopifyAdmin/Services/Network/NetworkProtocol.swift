//
//  NetworkProtocol.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 06/06/2023.
//

import Foundation

protocol NetworkProtocol{
    
    static func get<T: Decodable>(endPoint: EndPoints, completionHandeler: @escaping ((T?), Error?) -> Void)
    
    static func post<T: Codable>(endPoint: EndPoints, params: [String: Any], completionHandeler: @escaping ((T?), Error?) -> Void)
    
    static  func update<T: Codable>(endPoint: EndPoints, params: [String: Any], completionHandeler: @escaping ((T?), Error?) -> Void)
    
    static  func delete(endPoint: EndPoints)
    
}
