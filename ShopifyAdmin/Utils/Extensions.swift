//
//  Extensions.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 19/06/2023.
//

import Foundation
import UIKit


extension UIViewController {
    func showAlert(Title: String, Message: String) {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
    
    //    func popToContact(viewController:UIViewController.Type) {
    //        if let contactVC = self.navigationController?.viewControllers.filter { $0 is viewController}.first {
    //            self.navigationController?.popToViewController(contactVC, animated: true)
    //        }
    //    }
}

extension UIView {
    func giveShadowAndRadius(scale: Bool = true, shadowRadius:Int, cornerRadius:Int) {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
        layer.shadowRadius = CGFloat(integerLiteral: shadowRadius)
        layer.shouldRasterize = true
        layer.cornerRadius = CGFloat(integerLiteral: cornerRadius)
    }
    
    func showToastMessage(message: String, color: UIColor) {
        let toastLabel = UILabel(frame: CGRect(x: self.frame.width / 2 - 120, y: self.frame.height - 130, width: 260, height: 30))

        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = color
        toastLabel.textColor = .white
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.text = message
        self.addSubview(toastLabel)

        UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }) { _ in
            toastLabel.removeFromSuperview()
        }
    }
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}
extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime])
}
extension Date {
    var iso8601: String { return Formatter.iso8601.string(from: self) }
}
