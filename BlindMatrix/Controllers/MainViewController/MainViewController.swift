//
//  MainViewController.swift
//  BlindMatrix
//
//  Created by Jeyaganthan's Mac Mini on 16/09/21.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapTask1(_ sender: Any) {
        VC_List.setASRootVC()
    }
    
    @IBAction func didTapTask2(_ sender: Any) {
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
