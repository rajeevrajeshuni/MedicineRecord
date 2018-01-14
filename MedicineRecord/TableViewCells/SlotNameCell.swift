//
//  SlowNameViewCell.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/5/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//
protocol SlotNameCellDelegate:class {
    func SlotNameEditingDidBegin(_ cell: UITableViewCell,_ TextField: UITextField)
    func dismissKeyboard(_ cell: UITableViewCell,_ TextField: UITextField)
    func SlotNameEditingChanged(_ cell: UITableViewCell,_ sender: UITextField)
}
import Foundation
import UIKit
class SlotNameCell:UITableViewCell{
    @IBOutlet weak var SlotName: UITextField!
    weak var delegate:SlotNameCellDelegate?
    @IBAction func SlotNameEditingDidBegin(_ sender: UITextField) {
        //Make sure the done button in Table View Controller gets disabled when this is empty.
        
        self.delegate?.SlotNameEditingDidBegin(self,sender)
    }
    @IBAction func SlotNameEditingChanged(_ sender: UITextField) {
        //Make sure the done button in Table View Controller gets disabled when this is empty.
        
        self.delegate?.SlotNameEditingChanged(self,sender)
    }
    @IBAction func dismissKeyboard(_ sender: UITextField) {
        self.delegate?.dismissKeyboard(self, sender)
        //sender.endEditing(true)
    }
}
