//
//  LoginViewController.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 24/06/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    var loginViewModel:LoginViewModel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginViewModel = LoginViewModel()
        
        if(loginViewModel.isLoggedInBefore()){
            navigateToMain()
        }
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        
        if username.text == "" || password.text == "" {
            CustomAlerts.presentAlert(vc: self, title: Constants.error, message: Constants.emptyFields)
        }else{
            if loginViewModel.login(customerEmail: username.text ?? "", customerPasssword: password.text ?? ""){
                
                navigateToMain()
                self.errorLabel.text = "Login Successful"
                
            }
            else{
                
                self.errorLabel.text = "Invalid Account"
            }
        }

    }
    
    
    func navigateToMain(){
        
        // after login is done, maybe put this in the login web service completion block

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
}
