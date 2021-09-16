//
//  TypeUsersViewModel.swift
//  BlindMatrix
//
//  Created by Jeyaganthan's Mac Mini on 16/09/21.
//

import Foundation
import UIKit


class TypeUsersViewModel {
    var dataSource = GenericDataSource<Type_users>()
    var data = [Type_users]()
    
    func getData(){
        self.dataSource.data.value = data
    }
}

class TypeUserstblDataSource : GenericDataSource<Type_users>,UITableViewDataSource {

    var delegate: didSelectUser?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count ===>",self.data.value.count)
        return self.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UserTypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! UserTypeTableViewCell
        guard let data = self.data.value as? [Type_users] else {
            return cell
        }
        cell.lbl_id.text = Themes.shared.checkNull(data[indexPath.row].id)
        cell.lbl_userNAme.text = Themes.shared.checkNull(data[indexPath.row].user_name)
        return cell
    }
    
    
}
