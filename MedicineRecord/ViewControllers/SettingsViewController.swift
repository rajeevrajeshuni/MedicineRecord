//
//  SettingsViewController.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/5/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController:UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SettingViewCell", for: indexPath)
        //print(indexPath.row)
        return cell
    }
   // ShowMedicineSlotsSegue
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row==0)
        {
            performSegue(withIdentifier: "ShowMedicineSlotsSegue", sender: nil)
        }
    }
}
