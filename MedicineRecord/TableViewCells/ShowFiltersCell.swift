//
//  ShowFiltersCell.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/11/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import UIKit

protocol ShowFiltersCellDelegate:class{
    func HideGreenBarsButton_TouchUpInside(_ cell:UITableViewCell,_ HideGreenBarsButton:UIButton)
}
//This cell is part of GraphViewController class
class ShowFiltersCell: UITableViewCell{
    weak var delegate:ShowFiltersCellDelegate?
    @IBOutlet weak var HideGreenBarsButton:UIButton!
    
    @IBAction func HideGreenBarsButton_TouchUpInside(_ sender: UIButton)
    {
        self.delegate?.HideGreenBarsButton_TouchUpInside(self, sender)
    }
}
