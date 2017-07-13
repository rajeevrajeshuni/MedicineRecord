//
//  IdealTimePickerCell.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/5/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//
protocol IdealTimePickerDelegate:class {
    func IdealTimePicker_DateChanged(_ cell: UITableViewCell,_ IdealTimePicker: UIDatePicker)
}
import Foundation
import UIKit

class IdealTimePickerCell:UITableViewCell{
    
    weak var delegate:IdealTimePickerDelegate?
    @IBOutlet weak var IdealTimePicker: UIDatePicker!
    
    @IBAction func IdealTimePicker_ValueChanged(_ sender: UIDatePicker) {
        delegate?.IdealTimePicker_DateChanged(self, sender)
    }
}
