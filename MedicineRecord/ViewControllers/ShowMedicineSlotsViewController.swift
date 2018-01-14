//
//  MedicineSlotViewController.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/5/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
class ShowMecidineSlotsViewController:UITableViewController{
    var realm = try! Realm()
    var medicineslots:Results<MedicineSlot>!
    var sectionTouched = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        medicineslots = realm.objects(MedicineSlot.self).filter("current = %@",1).sorted(byKeyPath: "timeofDayinMinutes", ascending: true)
        printallmedicineslots()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //medicineslots = realm.objects(MedicineSlot.self).filter("current = 1").sorted(byKeyPath: "timeofDayinMinutes", ascending: true)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if(row==0)
        {
            return CGFloat(44)
        }
        return CGFloat(35)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        if(row>2)
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
            medicineslots[section].Medicines.remove(at: row-3)
            tableView.reloadSections([section], with: .automatic)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineslots[section].Medicines.count+3
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Slot "+String(section+1)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        var cell:UITableViewCell!
        if(row==0)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "SlotNameCell", for: indexPath)
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell", for: indexPath)
        }
        let label:UILabel = cell.viewWithTag(999) as! UILabel
        if(row==0)
        {
            label.text = medicineslots[section].SlotName
        }
        else if(row==1)
        {
            label.text = "Ideal Time - " + medicineslots[section].TimeinString()
        }
        else if(row==2)
        {
            label.text = "Acceptable Error Time - " + String(medicineslots[section].AcceptableErrorTime)+" Min"
        }
        else
        {
            label.text = medicineslots[section].Medicines[row-3].name + " - " + medicineslots[section].Medicines[row-3].dosage

        }
        return cell
    }
    @IBAction func EditButtonTouched(_ sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell) as! IndexPath
        print(indexPath.section)
        sectionTouched = indexPath.section
        performSegue(withIdentifier: "EditMedicineSlotSegue", sender: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if(medicineslots==nil)
        {
            return 0
        }
        else
        {
            return medicineslots.count
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="EditMedicineSlotSegue"){
            let NavigationController = segue.destination as! UINavigationController
            let destinationVC = NavigationController.topViewController as! AddMedicineSlotViewController
            destinationVC.edit = true
            destinationVC.medicineslot = medicineslots[sectionTouched]
        }
    }
    @IBAction func AddMedicineSlot(_ sender: Any) {
        performSegue(withIdentifier: "AddMedicineSlotSegue", sender: nil)
    }
    func prepareData() -> [MedicineSlot]
    {
        //idealTime:[Int],_ Medicines:[Medicine],_ slotName:String,_ errorTime:Int
        var names = ["Morning","Evening"]
        var medicine1 = Medicine(name:"Oxetol",dosage:"750mg")
        var medicine2 = Medicine(name:"Propanolol",dosage:"80mg")
        var medicine3 = Medicine(name:"Oxetol",dosage:"750mg")
        var medicine4 = Medicine(name:"Clobazam",dosage:"10mg")
        var temp1 = RealmSwift.List<Int>()
        temp1.append(9)
        temp1.append(0)
        var temp2 = RealmSwift.List<Int>()
        temp2.append(21)
        temp2.append(0)
        var temp1_medicine = RealmSwift.List<Medicine>()
        temp1_medicine.append(medicine1)
        temp1_medicine.append(medicine2)
        var temp2_medicine = RealmSwift.List<Medicine>()
        temp2_medicine.append(medicine3)
        temp2_medicine.append(medicine4)
        var slot1 = MedicineSlot(IdealTime:temp1,Medicines:temp1_medicine,SlotName:names[0],ErrorTime:15)
        var slot2 = MedicineSlot(IdealTime:temp2,Medicines:temp2_medicine,SlotName:names[1],ErrorTime:15)
        return [slot1,slot2]
    }
    @IBAction func DeleteButtonTouched(_ sender: UIButton)
    {
        let cell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell) as! IndexPath
        sectionTouched = indexPath.section
        let alert = UIAlertController(title:"Are you sure? This operation is permanent.",message:"",preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            try! self.realm.write {
                let medicineslot = self.medicineslots[self.sectionTouched]
                medicineslot.setValue("0",forKeyPath: "current")
            }
            self.tableView.reloadData()
        })
        let action2 = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert,animated: true,completion: nil)
    }
    func printallmedicineslots()
    {
        print("All medicine Slots")
        let medicineslots = realm.objects(MedicineSlot.self)
        for i in medicineslots{
            print(i.SlotName,i.current)
        }
    }
}
