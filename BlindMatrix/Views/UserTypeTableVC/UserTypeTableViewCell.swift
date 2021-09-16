//
//  UserTypeTableViewCell.swift
//  BlindMatrix
//
//  Created by Jeyaganthan's Mac Mini on 16/09/21.
//

import UIKit

class UserTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_id: UILabel!
    @IBOutlet weak var lbl_userNAme: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
