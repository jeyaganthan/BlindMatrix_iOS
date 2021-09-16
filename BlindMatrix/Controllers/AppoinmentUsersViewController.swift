//
//  AppoinmentUsersViewController.swift
//  BlindMatrix
//
//  Created by Jeyaganthan's Mac Mini on 16/09/21.
//

import UIKit

class AppoinmentUsersViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var tittleLbl: UILabel!
    @IBOutlet weak var txtCust_Type: UITextField!
    @IBOutlet weak var txtOrderStatus: UITextField!
    @IBOutlet weak var tbltypeOfUser: UITableView!
    let dataSource = AppoinmentListtblDataSource()
    private var customer_type = [String]()
    private var order_Status = [String]()
    lazy var viewModel : AppoinmentViewModel = {
        let viewModel = AppoinmentViewModel(dataSource: dataSource)
          return viewModel
      }()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbltypeOfUser.register(UINib(nibName: "AppoinmentTableViewCell", bundle: nil), forCellReuseIdentifier: "type_user")
        self.setInitial()
        self.viewModel.getdata()
        // Do any additional setup after loading the view.
        
    }

    
    private func setInitial(){
        self.dataSource.delegate = self
        self.tbltypeOfUser.dataSource = self.dataSource
        self.tbltypeOfUser.delegate = self.dataSource
        self.txtOrderStatus.delegate = self
        self.txtCust_Type.delegate = self
        self.viewModel.loadingClouser = {[weak self] status in DispatchQueue.main.async {
            self?.showLoader(status)
        } }
        self.viewModel.dataInfo = {[weak self] str, order, cust,defaultCust,def_order in print(str);
            DispatchQueue.main.async {
                self?.tittleLbl.text = Themes.shared.checkNull(str)
                self?.txtCust_Type.text = defaultCust
                self?.txtOrderStatus.text = def_order
                guard let data1 = cust, let data2 = order else {return}
                self?.customer_type = data1
                self?.order_Status = data2
            }
        }
        self.dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            DispatchQueue.main.async {self?.tbltypeOfUser.reloadData()}
                
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCust_Type {
            JeyPickerView.pickOption(dataArray: self.customer_type) { selectedValue, index in
                self.txtCust_Type.text = Themes.shared.checkNull(selectedValue)
            }
        } else if textField == txtOrderStatus {
            JeyPickerView.pickOption(dataArray: self.order_Status) { selectedValue, index in
                self.txtOrderStatus.text = Themes.shared.checkNull(selectedValue)
            }
        }
        
        return false
    }
}


extension AppoinmentUsersViewController : didSelectUser {
    func didSelecttableView(data: [Type_users]?, name: String) {
        let vc = setVC_FromID(viewControllerID: VC_List.typeUserVC, storyBoardName: .Main) as! UsertypeLisViewController
        vc.dataSource.data.value = data!
        vc.titleStr = name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
