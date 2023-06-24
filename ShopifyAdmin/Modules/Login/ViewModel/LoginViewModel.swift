//
//  LoginViewModel.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 24/06/2023.
//

import Foundation

class LoginViewModel{
    
    func login(customerEmail:String,customerPasssword:String)->Bool{
        var isValid = false
        if customerEmail == "admin@gmail.com" && customerPasssword == "admin1234"{
            isValid = true
            UserDefaults.standard.set(isValid, forKey: "isValid")
            let userDefultId =  UserDefaults.standard.bool(forKey:"isValid")
            print("isValid", userDefultId )
        }
        return isValid
    }
    
    func isLoggedInBefore()-> Bool{
        return UserDefaults.standard.bool(forKey:"isValid")
    }
    
    
}
