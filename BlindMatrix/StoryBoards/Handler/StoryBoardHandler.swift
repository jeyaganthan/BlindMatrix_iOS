//
//  StoryBoardHandler.swift
//  BlindMatrix
//
//  Created by Jeyaganthan's Mac Mini on 16/09/21.
//

import Foundation
import UIKit

public func setVC_FromID(viewControllerID : String , storyBoardName: AppStoryBoard) -> UIViewController?{
    let storyboard =  UIStoryboard(name: storyBoardName.rawValue, bundle: Bundle.main)
    let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerID)
    return viewController
}

public enum AppStoryBoard : String{
    case Main = "Main"
    case second = "SecondTask"
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

class VC_List {
    static let AppoinmentUserVCID = "UserListVCID"
    static let typeUserVC = "typeUserVC"
    
    static let loginVC = "loginVCID"
    static let LoginRootVC = "LoginRootVCID"
    static let signupRootVC = "SignupRootVCID"
    
    
    
    static func setLoginASRootVC(){
        let mainStoryBoard = UIStoryboard(name: "SecondTask", bundle: nil)
        let mainInitialVC:UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: VC_List.LoginRootVC)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
       // appdelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appdelegate.window?.rootViewController = mainInitialVC
        appdelegate.window?.makeKeyAndVisible()
        
    }
    
    
    static func setSignupASRootVC(){
        let mainStoryBoard = UIStoryboard(name: "SecondTask", bundle: nil)
        let mainInitialVC:UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: VC_List.signupRootVC)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
       // appdelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appdelegate.window?.rootViewController = mainInitialVC
        appdelegate.window?.makeKeyAndVisible()
    }

}
