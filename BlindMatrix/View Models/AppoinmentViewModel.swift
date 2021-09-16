//
//  AppoinmentViewModel.swift
//  BlindMatrix
//
//  Created by Jeyaganthan's Mac Mini on 16/09/21.
//

import Foundation
import UIKit


struct AppoinmentViewModel {
    weak var dataSource : GenericDataSource<Appointment_type_list>?
    
    var onErrorHandling : (() -> ())?
    var loadingClouser : ((_ status: Bool) -> ()) = {_ in }
    var alertClosure : ((_ error:String) -> ()) = {_ in}
    var dataInfo : ((_ title : String, _ order_status: [String]?, _ cust_type:[String]?,_ default_Cust: String?, _ default_order:String?)-> ()) = {_,_,_,_,_ in}

    
    init(dataSource : GenericDataSource<Appointment_type_list>) {
        self.dataSource = dataSource
    }
    
    func getdata(){
        self.loadingClouser(true)
        let params: Parameters = ["platform":"ios","mode":"appointmentdetails","type":"new","company_name":"BMDEMO","userid":"1"]
        APIRequestManager.makePostRequest(path: "testbm/iostest.php", body: params) { (result: Appointment_Base?, error) in
            self.loadingClouser(false)
            switch error {
            case .none:
               
                if Themes.shared.checkNull(result?.status) == "success"{
                    if let cust_type = result?.customer_type, let order = result?.order_status {
                        self.dataInfo(Themes.shared.checkNull(result?.message),order,cust_type,Themes.shared.checkNull(result?.default_cust_type),Themes.shared.checkNull(result?.default_order_status))
                    }else {
                        self.dataInfo(Themes.shared.checkNull(result?.message),nil,nil,Themes.shared.checkNull(result?.default_cust_type),Themes.shared.checkNull(result?.default_order_status))
                    }
                    
                    guard let data = result?.appointment_type_list else {
                        return
                    }
                    self.dataSource?.data.value = data
                }
            case .apiFailure:
                print("Decodeing Error")
                return
            case .decodingError :
                print("Decodeing Error")
                return
            case .invalidResponse :
                print("No Invalid Response")
                return
            case .noInternet :
                print("No Internet")
                return
            }
            
        }
    }
}



class AppoinmentListtblDataSource : GenericDataSource<Appointment_type_list>,UITableViewDelegate,UITableViewDataSource {

    var delegate: didSelectUser?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : AppoinmentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "type_user", for: indexPath) as! AppoinmentTableViewCell
        cell.lbl_TypeName.text = Themes.shared.checkNull(self.data.value[indexPath.row].typename)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelecttableView(data: self.data.value[indexPath.row].type_users ?? nil)
    }
    
    
}


protocol didSelectUser {
    func didSelecttableView(data: [Type_users]?)
}
