//
//  UsertypeLisViewController.swift
//  BlindMatrix
//
//  Created by Jeyaganthan's Mac Mini on 16/09/21.
//

import UIKit

class UsertypeLisViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblUserType: UITableView!
    let dataSource = TypeUserstblDataSource()
    var titleStr : String = ""
    lazy var viewModel : TypeUsersViewModel = {
        let viewModel = TypeUsersViewModel()
          return viewModel
      }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = titleStr
        self.tblUserType.register(UINib(nibName: "UserTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "user")
        self.tblUserType.dataSource = self.dataSource
        self.setInitial()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setInitial(){
//        self.viewModel.getData()
        self.dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            DispatchQueue.main.async {self?.tblUserType.reloadData()}
                
        }
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
