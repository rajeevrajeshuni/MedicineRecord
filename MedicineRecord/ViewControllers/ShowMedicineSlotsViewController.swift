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
    var rowTouched = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        medicineslots = realm.objects(MedicineSlot.self).sorted(byKeyPath: "timeofDay", ascending: true)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = UIView(frame: .zero)
        //printallmedicineslots()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //medicineslots = realm.objects(MedicineSlot.self).filter("current = 1").sorted(byKeyPath: "timeofDayinMinutes", ascending: true)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(44)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let alertController = UIAlertController(title:"Are you sure?", message:"This operation is permanent.", preferredStyle: .alert)
            let alertAction_yes = UIAlertAction(title: "Yes", style: .destructive, handler: {
                (action) -> Void in
                try! self.realm.write {
                    self.realm.delete(self.medicineslots[row])
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            
            alertController.addAction(alertAction_yes)
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(medicineslots==nil)
        {
            return 0;
        }
        return medicineslots.count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    /*override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Slot "+String(section+1)
    }*/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let section = indexPath.section
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeAndErrorCell", for: indexPath)
        let label:UILabel = cell.viewWithTag(999) as! UILabel
        label.text = UIMethods.TimeinString(medicineslots[row].timeofDay) + " - " + String(medicineslots[row].AcceptableErrorTime) + "min"
        return cell
    }
    /*@IBAction func EditButtonTouched(_ sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell) as! IndexPath
        print(indexPath.section)
        sectionTouched = indexPath.section
        performSegue(withIdentifier: "EditMedicineSlotSegue", sender: nil)
    }*/
    
    /*override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }*/
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="EditMedicineSlotSegue"){
            let NavigationController = segue.destination as! UINavigationController
            let destinationVC = NavigationController.topViewController as! AddMedicineSlotViewController
            destinationVC.edit = true
            destinationVC.medicineslot = medicineslots[sectionTouched]
        }
    }*/
    @IBAction func AddMedicineSlot(_ sender: Any) {
        performSegue(withIdentifier: "AddMedicineSlotSegue", sender: nil)
    }
    /*func prepareData() -> [MedicineSlot]
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
    }*/
    /*func printallmedicineslots()
    {
        print("All medicine Slots")
        let medicineslots = realm.objects(MedicineSlot.self)
        for i in medicineslots{
            print(i.SlotName,i.current)
        }
    }*/
}
