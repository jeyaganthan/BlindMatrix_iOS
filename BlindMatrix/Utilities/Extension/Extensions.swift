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

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}

protocol PropertyLoopable
{
    func allProperties() throws -> [String: Any]
}

extension PropertyLoopable
{
    func allProperties() throws -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)

        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            //throw some error
            throw NSError(domain: "hris.to", code: 777, userInfo: nil)
        }

        for (labelMaybe, valueMaybe) in mirror.children {
            guard let label = labelMaybe else {
                continue
            }

            result[label] = valueMaybe
        }

        return result
    }
}
