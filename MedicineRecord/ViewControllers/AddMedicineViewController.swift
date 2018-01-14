//
//  AddMedicineViewController.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/7/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import UIKit
protocol AddMedicineDelegate:class {
    func saveMedicine_FinishAdding(_ controller:AddMedicineViewController,_ temp_name:String,_ temp_dosage:String)
    func saveMedicine_FinishEditing(_ controller:AddMedicineViewController,_ temp_name:String,_ temp_dosage:String,_ row:Int)
}

class AddMedicineViewController:UITableViewController{
    var edit = false
    var row = -1
    weak var delegate:AddMedicineDelegate?
    var temp_name = ""
    var temp_dosage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        MedicineTextField.text = temp_name
        DosageTextField.text = temp_dosage
        SaveButton.isEnabled=false
    }
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var DosageTextField: UITextField!
    @IBOutlet weak var MedicineTextField: UITextField!
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(44)
    }
    @IBAction func MedicineNameChanged(_ sender: Any) {
        temp_name = MedicineTextField.text!
        if(MedicineTextField.text!.count>0 && DosageTextField.text!.count>0)
        {
            SaveButton.isEnabled=true
        }
        else
        {
            SaveButton.isEnabled=false
        }
        print(temp_name)
    }
    @IBAction func DosageChanged(_ sender: Any)
    {
       temp_dosage = DosageTextField.text!
       if(MedicineTextField.text!.count>0 && DosageTextField.text!.count>0)
        {
            SaveButton.isEnabled=true
        }
       else
       {
          SaveButton.isEnabled=false
        }
        print(temp_dosage)
    }
    @IBAction func MedicinedismissKeyboard(_ sender: Any)
    {
        self.view.endEditing(true)
    }
    @IBAction func DosagedismissKeyboard(_ sender: Any)
    {
        self.view.endEditing(true)
    }
    @IBAction func TouchCancelButton(_ sender: Any) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func TouchSaveButton(_ sender: Any) {
        self.view.endEditing(true)
        print("Save Button Touched")
        if(!edit)
        {
            delegate?.saveMedicine_FinishAdding(self,temp_name,temp_dosage)
        }
        else
        {
            
            delegate?.saveMedicine_FinishEditing(self,temp_name,temp_dosage,row)
        }
    }
}
