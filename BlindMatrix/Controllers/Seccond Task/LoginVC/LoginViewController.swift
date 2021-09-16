//
//  LoginViewController.swift
//  BlindMatrix
//
//  Created by Jeyaganthan's Mac Mini on 16/09/21.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    @IBOutlet weak var emailView: CustomView!
    @IBOutlet weak var passwordView: CustomView!
    
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtPassword.delegate = self
        self.txt_Email.delegate = self
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func didTapSignIn(_ sender:Any){
        
        guard let email = self.txt_Email.text, email.count > 0 else {
            NotificationMessage.shared.showError("Please enter the email")
            return
        }
        
        if !email.validEmail(){
            NotificationMessage.shared.showError("Please enter valid email")
            return
        }
        
        guard let password = self.txtPassword.text, password.count > 0  else {
            NotificationMessage.shared.showError("Please enter password")
            return
        }
        
        if !password.validPassword() {
            NotificationMessage.shared.showError("Your password must contain atleast one number and must be a minimum 8 charecter long")
            return
        }
        
        let emailCount = DatabaseHandler.sharedInstance.countForDataForTable(Entityname: "Login", attribute: "email", FetchString: email)
        if !emailCount  {
            let data = DatabaseHandler.sharedInstance.FetchFromDatabase(Entityname: "Login", attribute: "email", FetchString: email, SortDescriptor: nil) as! NSArray
            
            let managedObj = data[0] as! NSManagedObject
            
            let password_db = Themes.shared.checkNull(managedObj.value(forKey: "password"))
            if password == password_db {
                NotificationMessage.shared.showSucess("Login succesfully")
                return
            } else {
                NotificationMessage.shared.showError("Invalid Password")
                return
            }
        }else {
            NotificationMessage.shared.showError("Invalid User")
            return
        }
        
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        VC_List.setSignupASRootVC()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txt_Email {
            self.showShadow(views: self.emailView, isShow: true)
            self.showShadow(views: self.passwordView, isShow: false)
            return true
        }else {
            self.showShadow(views: self.emailView, isShow: false)
            self.showShadow(views: self.passwordView, isShow: true)
            return true
        }
        
    }
    
    
    func showShadow(views:CustomView,isShow:Bool){
        if isShow{
            views.shadowRadius = 6.0
            views.shadowOpacity = 0.7
            views.shadowColor = .lightGray
        }else {
            views.shadowRadius = 0.0
            views.shadowOpacity = 0.0
            views.shadowColor = .clear
        }
    }
}
