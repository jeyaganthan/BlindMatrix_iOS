//
//  RegistrationViewController.swift
//  BlindMatrix
//
//  Created by Jeyaganthan's Mac Mini on 16/09/21.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    
    
    @IBOutlet weak var userNameView: CustomView!
    @IBOutlet weak var emailView: CustomView!
    @IBOutlet weak var passwordView: CustomView!
    @IBOutlet weak var addressView: CustomView!
    @IBOutlet weak var phoneView: CustomView!
    
    fileprivate var checkoxArr = [UIButton]()
    fileprivate var shadowArr = [CustomView]()
    
    var gender = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkoxArr = [btnMale,btnFemale]
        self.shadowArr = [userNameView,emailView,passwordView,addressView,phoneView]
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapCheckBox(_ sender: UIButton){
        self.checkoxArr.forEach{
            $0.isSelected = false
        }
        sender.isSelected = true
        self.gender = sender.tag
    }
    
    private func showShadow(_ customView: CustomView){
        self.shadowArr.forEach{
            $0.shadowRadius = 0.0
            $0.shadowOpacity = 0.0
            $0.shadowColor = .clear
        }
        
        customView.shadowRadius = 0.6
        customView.shadowOpacity = 0.7
        customView.shadowColor = .gray
    }
    @IBAction func didTapSignup(_ sender: Any) {
        
        guard let fName = self.txtUserName.text , fName.count > 0 else {
            NotificationMessage.shared.showError("Please enter username")
            return
        }
        
        guard let email = self.txtEmail.text, email.count > 0 else {
            NotificationMessage.shared.showError("Please enter email")
            return
        }
        if !email.validEmail() {
            NotificationMessage.shared.showError("Please enter valid email")
            return
        }
        
        guard let password = self.txtPassword.text, password.count > 0 else {
            NotificationMessage.shared.showError("Please enter password")
            return
        }
        
        if !password.validPassword() {
            NotificationMessage.shared.showError("Your password must contain atleast one number and must be a minimum 8 charecter long")
            return
        }
        
        guard let address = self.txtAddress.text, address.count > 0 else {
            NotificationMessage.shared.showError("Please enter address")
            return
        }
        
        guard let phone = self.txtPhone.text, phone.count > 0 else {
            NotificationMessage.shared.showError("Please enter phone number")
            return
        }
        
        if gender == 0 {
            NotificationMessage.shared.showError("Please gender")
            return
        }
        
        let genderStr = self.genderSelected(_val: self.gender)
        
        let dict = ["username":fName,"phone":phone,"password":password,"gender":genderStr,"email":email,"address":address] as [String : Any]
        
        
        let emailCount = DatabaseHandler.sharedInstance.countForDataForTable(Entityname: "Login", attribute: "email", FetchString: email)
        if emailCount  { 
            NotificationMessage.shared.showError("This email \(email) is already exist")
            return
        }else {
            let phoneCount = DatabaseHandler.sharedInstance.countForDataForTable(Entityname: "Login", attribute: "phone", FetchString: phone)
            
            if phoneCount {
                NotificationMessage.shared.showError("This phonenumber \(phone) is already exist")
                return
            } else {
                DatabaseHandler.sharedInstance.InserttoDatabase(Dict: dict as NSDictionary, Entityname: "Login")
                NotificationMessage.shared.showSucess("Register sucessfully completed.")
                return
            }
            
        }
        
       
        
    }
    
    private func genderSelected(_val:Int) -> String{
        switch _val {
        case 1:
            return "Male"
        case 2:
            return "Female"
        default:
            return "Male"
        }
    }
    
    @IBAction func didTapSignIn(_ sender: Any) {
        VC_List.setLoginASRootVC()
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

extension RegistrationViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.txtEmail == textField {
            self.showShadow(self.emailView)
        } else if self.txtUserName == textField {
            self.showShadow(self.userNameView)
        }else if self.txtPassword == textField {
            self.showShadow(self.passwordView)
        }else if self.txtPhone == textField {
            self.showShadow(self.phoneView)
        }else if self.txtAddress == textField {
            self.showShadow(self.addressView)
        }
        return true
    }
}

