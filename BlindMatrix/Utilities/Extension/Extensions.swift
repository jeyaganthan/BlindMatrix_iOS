//
//  Extensions.swift
//  BlindMatrix
//
//  Created by Jeyaganthan's Mac Mini on 16/09/21.
//
import Foundation
import UIKit
import APESuperHUD


extension UIViewController {
  
    
    func showLoader(_ status: Bool) {
        
        if status {
            DispatchQueue.main.async {
                self.view.endEditing(true)
                HUDAppearance.loadingActivityIndicatorColor =  UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
                HUDAppearance.cancelableOnTouch = false
                APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: nil)
            }
           
        }else {
            DispatchQueue.main.async {
                self.view.endEditing(true)
                APESuperHUD.dismissAll(animated: true)
            }
        }
    }
    
}

extension String {
    
    func validEmail()-> Bool{
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: self)
    }
    
    func validPassword()-> Bool {
        let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
       
    }
    
}
