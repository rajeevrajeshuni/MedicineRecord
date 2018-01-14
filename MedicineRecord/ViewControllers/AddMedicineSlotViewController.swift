//
//  AddMedicineSlotViewController.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/5/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
class AddMedicineSlotViewController:UITableViewController{
    
   // Add the option of including the current variable in MedicineSlot object.
    
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var CancelButton: UIBarButtonItem!
    var rowTouched:Int = -1
    //idealTime:[Int],Medicines:[Medicine],slotName:String,errorTime:Int)
    var edit:Bool = false
    var slotNames = ["Slot Name","Time","Medicines"]
    var realm = try! Realm()
    var temp_Int_list:[Int] = [0,0]
    var temp_Medicine_list:[Medicine] = []
    var temp_ErrorTime = 0
    var temp_Name = ""
    var slotID: String!
    var medicineslot:MedicineSlot!
    let ShowTimeCell_IdealTime_IndexPath = IndexPath(row:0,section:1)
    let IdealTimePickerCell_IndexPath = IndexPath(row:1,section:1)
    let ShowTimeCell_AcceptableErrorTime_IndexPath = IndexPath(row:2,section:1)
    let AcceptableErrorTimePickerCell_IndexPath = IndexPath(row:3,section:1)
    //This will be true if Showcell cell showing IdealTime is clicked.
    var ShowTimeCell_IdealTime_Clicked = false
    
    //This will be true if Showcell cell showing AcceptableErrorTime is clicked.
    var ShowTimeCell_AcceptableErrorTime_Clicked = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if(edit){
            title = "Edit Medicine Slot"
            //filling temp_Medicine_list
            for i in medicineslot.Medicines
            {
                temp_Medicine_list.append(i)
            }
            temp_Int_list[0] = medicineslot.IdealTime[0]
            temp_Int_list[1] = medicineslot.IdealTime[1]
            temp_Name = medicineslot.SlotName
            temp_ErrorTime = medicineslot.AcceptableErrorTime
            slotID = medicineslot.SlotID
        }
       // tableView.numberOfSections = 4
        else{
            SaveButton.isEnabled=false
        }
        tableView.tableFooterView = UIView(frame: .zero)
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return slotNames[section]
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return 1
        case 1:
            return 8
        case 2:
            return temp_Medicine_list.count+1
        default:
            print("Section ",section)
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        if(section==1 && row==1)
        {
            if(ShowTimeCell_IdealTime_Clicked)
            {
                return CGFloat(162)
            }
            else
            {
                return CGFloat(0)
            }
        }
        else if(section==1 && row>2)
        {
            if(ShowTimeCell_AcceptableErrorTime_Clicked)
            {
                return CGFloat(44)
            }
            else
            {
                return CGFloat(0)
            }
        }
        else
        {
            return CGFloat(44)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if(section==1 && row==0)
        {
            //clicked on ShowTimeCell with IdealTime
            
            //Closing other textfield and Time picker
            if(ShowTimeCell_AcceptableErrorTime_Clicked)
            {
                ShowTimeCell_AcceptableErrorTime_Clicked = false
                let tempIndexPaths = [ShowTimeCell_AcceptableErrorTime_IndexPath,AcceptableErrorTimePickerCell_IndexPath]
                tableView.reloadRows(at: tempIndexPaths, with: .automatic)
            }
            self.view.endEditing(true)
            
            let cell = tableView.cellForRow(at: indexPath) as! ShowTimeCell
            let timepickerIndexPath = IndexPath(row: 1, section: 1)
            let timepickerCell = tableView.cellForRow(at: timepickerIndexPath) as! IdealTimePickerCell
            if(cell.Time.textColor == UIColor.red)
            {
                cell.Time.textColor = UIColor.black
                cell.TimeString.textColor = UIColor.black
                ShowTimeCell_IdealTime_Clicked = false
                //IdealTimePicker = false
                //timepickerCell.isHidden = true
                tableView.reloadRows(at: [timepickerIndexPath], with: .automatic)
            }
            else
            {
                cell.Time.textColor = UIColor.red
                cell.TimeString.textColor = UIColor.red
                ShowTimeCell_IdealTime_Clicked = true
                //IdealTimePicker = true
                //timepickerCell.isHidden = false
                tableView.reloadRows(at: [timepickerIndexPath], with: .automatic)
            }
        }
        if(section==1 && row==2)
        {
            //clicked on ShowTimeCell with AcceptableErrorTime
            
            //Closing other textfield and Time picker
            if(ShowTimeCell_IdealTime_Clicked)
            {
                ShowTimeCell_IdealTime_Clicked = false
                let tempIndexPaths = [ShowTimeCell_IdealTime_IndexPath,IdealTimePickerCell_IndexPath]
                tableView.reloadRows(at: tempIndexPaths, with: .automatic)
            }
            self.view.endEditing(true)
            
            let cell = tableView.cellForRow(at: indexPath) as! ShowTimeCell
            let AcceptableErrortimepickerIndexPath = IndexPath(row: 3, section: 1)
            let AcceptableErrortimepickerCell = tableView.cellForRow(at: AcceptableErrortimepickerIndexPath) as! AcceptableErrorTimePickerCell
            if(cell.Time.textColor == UIColor.red)
            {
                cell.Time.textColor = UIColor.black
                cell.TimeString.textColor = UIColor.black
                ShowTimeCell_AcceptableErrorTime_Clicked = false
                //AcceptableErrorTimePicker = false
                //timepickerCell.isHidden = true
                tableView.reloadRows(at: [AcceptableErrortimepickerIndexPath], with: .automatic)
            }
            else
            {
                cell.Time.textColor = UIColor.red
                cell.TimeString.textColor = UIColor.red
                ShowTimeCell_AcceptableErrorTime_Clicked = true
               // AcceptableErrorTimePicker = true
                //timepickerCell.isHidden = false
                tableView.reloadRows(at: [AcceptableErrortimepickerIndexPath], with: .automatic)
            }
            
        }
        if(section==1 && row>2)
        {
            closeAllOpenInputs()
            
            let previousRow = (temp_ErrorTime/15) + 3 // Adding 3 to account for top 3 rows
            let previousRowIndexPath = IndexPath(row:previousRow,section:1)
            let previouscell = tableView.cellForRow(at: previousRowIndexPath) as! AcceptableErrorTimePickerCell
            previouscell.accessoryType = .none
            
            let selectedcell = tableView.cellForRow(at: indexPath) as! AcceptableErrorTimePickerCell
            selectedcell.accessoryType = .checkmark
            temp_ErrorTime = (indexPath.row-3)*15 //Removing 3 to account for top 3 rows
            tableView.reloadRows(at: [IndexPath(row:2,section:1)], with: .automatic)
            
        }
        if(section==2)
        {
            closeAllOpenInputs()
            
            if(row==temp_Medicine_list.count)
            {
                performSegue(withIdentifier: "AddMedicineSegue", sender: nil)
            }
            else
            {
                rowTouched = row
                performSegue(withIdentifier: "EditMedicineSegue", sender: nil)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //EditMedicineSegue
        if(segue.identifier == "EditMedicineSegue")
        {
          //Send the Medicine
            let NavigationController = segue.destination as! UINavigationController
            let destinationVC = NavigationController.topViewController as! AddMedicineViewController
            destinationVC.row = rowTouched
            destinationVC.temp_name = temp_Medicine_list[rowTouched].name
            destinationVC.temp_dosage = temp_Medicine_list[rowTouched].dosage
            destinationVC.edit = true
            destinationVC.delegate = self
            destinationVC.title = "Edit Medicine"
            rowTouched = -1
        }
        else if(segue.identifier == "AddMedicineSegue")
        {
            let NavigationController = segue.destination as! UINavigationController
            let destinationVC = NavigationController.topViewController as! AddMedicineViewController
            destinationVC.delegate = self
            destinationVC.title = "Add Medicine"
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        if(section==2 && row<temp_Medicine_list.count)
        {
            return true
        }
        return false
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            temp_Medicine_list.remove(at: row)
            print(temp_Medicine_list)
            tableView.reloadSections([2], with: .automatic)
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        switch(section){
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlotNameCell", for: indexPath) as! SlotNameCell
            cell.SlotName.text = temp_Name
            cell.delegate = self
            return cell
        case 1:
            if(row==0)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTimeCell", for: indexPath) as! ShowTimeCell
                cell.Time.text = "Ideal Time"
                cell.TimeString.text = TimeinString(temp_Int_list)
                
                if(ShowTimeCell_IdealTime_Clicked)
                {
                    cell.Time.textColor = UIColor.red
                    cell.TimeString.textColor = UIColor.red
                }
                else
                {
                    cell.Time.textColor = UIColor.black
                    cell.TimeString.textColor = UIColor.black
                }
                return cell
                
            }
            else if(row==1)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IdealTimePickerCell", for: indexPath) as! IdealTimePickerCell
                cell.delegate=self
                //let date = Calendar.current
                //print(date)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm"
                let DateTime = formatter.date(from: "2016/10/08 " + String(temp_Int_list[0]) + ":" + String(temp_Int_list[1]))
                print("Setting time of Ideal Time Picker String " + String(describing:DateTime))
               cell.IdealTimePicker.setDate(DateTime!, animated: false)
                return cell
            }
            else if(row==2)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTimeCell", for: indexPath) as! ShowTimeCell
                cell.Time.text = "Acceptable Error Time"
                cell.TimeString.text = String(temp_ErrorTime)+" Min"
                if(ShowTimeCell_AcceptableErrorTime_Clicked)
                {
                    cell.Time.textColor = UIColor.red
                    cell.TimeString.textColor = UIColor.red
                }
                else
                {
                    cell.Time.textColor = UIColor.black
                    cell.TimeString.textColor = UIColor.black
                }
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptableErrorTimePickerCell", for: indexPath) as! AcceptableErrorTimePickerCell
                //Setting the cell labels to 0,15,30,45,60
                cell.TimeLabel.text = String(15*(row-3))
                let currentActiveRow = 3+(temp_ErrorTime/15)
                if(row==currentActiveRow)
                {
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryType.none
                }
                return cell
            }
        case 2:
            if(row < temp_Medicine_list.count)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineNameDosageStringCell", for: indexPath) as! MedicineNameDosageStringCell
                cell.MedicineNameDosageString.text = temp_Medicine_list[row].name + " - " + temp_Medicine_list[row].dosage
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddMedicineCell", for: indexPath)
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddMedicineCell", for: indexPath)
            
            return cell
        }
    }
    @IBAction func TouchSaveButton(_ sender: Any) {
        closeAllOpenInputs()
        saveMedicineSlot()
        dismiss(animated:true, completion:nil)
    }
    @IBAction func TouchCancelButton(_ sender: Any) {
        closeAllOpenInputs()
        dismiss(animated:true, completion:nil)
    }
    func saveMedicineSlot(){
        //Saving Medicine Slot in DataBase
        var Int_List = RealmSwift.List<Int>()
        var Medicine_List = RealmSwift.List<Medicine>()
        for i in temp_Int_list{
            Int_List.append(i)
        }
        for i in temp_Medicine_list{
            Medicine_List.append(i)
        }
        medicineslot = MedicineSlot(IdealTime:Int_List,Medicines:Medicine_List,SlotName:temp_Name,ErrorTime:temp_ErrorTime)
        if(edit)
        {
            try! realm.write
            {
                realm.add(medicineslot)
                let old = realm.objects(MedicineSlot.self).filter("SlotID = %@",slotID)
                print("old Slot Name",old[0].SlotName)
                old[0].setValue(0, forKey:"current")
            }
        }
        else
        {
            try! realm.write
            {
                realm.add(medicineslot)
            }
        }
        print(medicineslot.SlotName)
        for i in 0..<medicineslot.Medicines.count{
            print(medicineslot.Medicines[i].name)
            print(medicineslot.Medicines[i].dosage)
        }
        print(medicineslot.IdealTime)
        print(medicineslot.AcceptableErrorTime)
        print(medicineslot.SlotID)
    }
    func TimeinString(_ time:[Int])->String
    {
        var hour = String(time[0])
        var minutes = String(time[1])
        //var ans:String = ""
        if(time[0]==0)
        {
            hour = "12"
        }
        if(minutes.count==1)
        {
            minutes = "0"+minutes
        }
        if(hour.count==1)
        {
            hour = "0"+hour
        }
        if(time[0]<12)
        {
            return String(hour) + ":" + String(minutes) + " AM"
        }
        else if(time[0]==12)
        {
            return String(time[0]) + ":" + String(minutes) + " PM"
        }
        else
        {
            return String(time[0]-12) + ":" + String(minutes) + " PM"
        }
    }
}
extension AddMedicineSlotViewController:SlotNameCellDelegate{
    
    //SlotNameCellDelegate
    func dismissKeyboard(_ cell: UITableViewCell, _ TextField: UITextField) {
        print("2")
        self.view.endEditing(true)
    }
    func SlotNameEditingChanged(_ cell: UITableViewCell,_ TextField: UITextField)
    {
        print("1")
        print(TextField.text)
        temp_Name = TextField.text!
        if(temp_Name.count>0 && temp_Medicine_list.count>0)
        {
            SaveButton.isEnabled=true
        }
        else
        {
            SaveButton.isEnabled=false
        }
    }
    func SlotNameEditingDidBegin(_ cell: UITableViewCell, _ TextField: UITextField) {
        
        if(ShowTimeCell_IdealTime_Clicked)
        {
            ShowTimeCell_IdealTime_Clicked = false
            let tempIndexPaths = [ShowTimeCell_IdealTime_IndexPath,IdealTimePickerCell_IndexPath]
            tableView.reloadRows(at: tempIndexPaths, with: .automatic)
        }
        if(ShowTimeCell_AcceptableErrorTime_Clicked)
        {
            ShowTimeCell_AcceptableErrorTime_Clicked = false
            let tempIndexPaths = [ShowTimeCell_AcceptableErrorTime_IndexPath,AcceptableErrorTimePickerCell_IndexPath]
            tableView.reloadRows(at: tempIndexPaths, with: .automatic)
        }
        
       
    }
}
extension AddMedicineSlotViewController:AddMedicineDelegate{
    //AddMedicineDelegate
    func saveMedicine_FinishEditing(_ controller:AddMedicineViewController,_ temp_name:String,_ temp_dosage:String,_ row:Int)
    {
        var medicine = Medicine(name: temp_name, dosage: temp_dosage)
        medicine.MedicineID = temp_Medicine_list[row].MedicineID
        try! realm.write
        {
            realm.add(medicine, update: true)
        }
        tableView.reloadSections([2], with: .automatic)
        dismiss(animated: true, completion: nil)
    }
    func saveMedicine_FinishAdding(_ controller:AddMedicineViewController,_ temp_name:String,_ temp_dosage:String)
    {
        var medicine = Medicine(name: temp_name, dosage: temp_dosage)
        print("Adding Medicine in AddMedicineSlotViewController",medicine)
        temp_Medicine_list.append(medicine)
        tableView.reloadSections([2], with: .automatic)
        dismiss(animated: true, completion: nil)
        if(temp_Name.count>0 && temp_Medicine_list.count>0)
        {
            SaveButton.isEnabled=true
        }
        else
        {
            SaveButton.isEnabled=false
        }
    }
    func closeAllOpenInputs()
    {
        if(ShowTimeCell_IdealTime_Clicked)
        {
            ShowTimeCell_IdealTime_Clicked = false
            let tempIndexPaths = [ShowTimeCell_IdealTime_IndexPath,IdealTimePickerCell_IndexPath]
            tableView.reloadRows(at: tempIndexPaths, with: .automatic)
        }
        if(ShowTimeCell_AcceptableErrorTime_Clicked)
        {
            ShowTimeCell_AcceptableErrorTime_Clicked = false
            let tempIndexPaths = [ShowTimeCell_AcceptableErrorTime_IndexPath,AcceptableErrorTimePickerCell_IndexPath]
            tableView.reloadRows(at: tempIndexPaths, with: .automatic)
        }
        self.view.endEditing(true)
    }
}
extension AddMedicineSlotViewController:IdealTimePickerDelegate{
    func IdealTimePicker_DateChanged(_ cell: UITableViewCell, _ IdealTimePicker: UIDatePicker) {
        let IdealTimeStringIndexPath = IndexPath.init(row: 0, section: 1)
        var datePassed = IdealTimePicker.date
        //datePassed.addTimeInterval(19800) //Changing the time to IST
        let hour = Calendar.current.component(.hour, from: datePassed)
        let minute = Calendar.current.component(.minute, from: datePassed)
        temp_Int_list[0] = hour
        temp_Int_list[1] = minute
        print("IdealTimeChanged:",temp_Int_list)
        tableView.reloadRows(at: [IdealTimeStringIndexPath], with: .automatic)
        //print(datePassed)
    }
}
