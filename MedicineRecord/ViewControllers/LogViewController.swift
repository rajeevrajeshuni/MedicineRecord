//
//  FirstViewController.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 12/23/17.
//  Copyright © 2017 Rajeev Rajeshuni. All rights reserved.
//

import UIKit
import Photos
import Foundation
import Charts
import RealmSwift

class LogViewController: UITableViewController {
    let albumName = "Tablets"
    var realm = try! Realm()
    var records:Results<Record>!
    //let maxLimit = 60
    var record:Record!
    var slotID:Int!
    var medicineslot:MedicineSlot!
    var medicineSlots:Results<MedicineSlot>?
    var medicineSlotsCount:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Don't extract all at once for optimization
        records = realm.objects(Record.self).sorted(byKeyPath: "timestamp", ascending: false)
        print(records.count,"Records Count")
       medicineSlots = realm.objects(MedicineSlot.self)
        if let medicineSlots = medicineSlots
        {
           medicineSlotsCount = medicineSlots.count
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // StartingRealmMethods.addEntriestoRealm()
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row<medicineSlotsCount)
        {
            return true
        }
        return false
    }
    /*override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(indexPath.row<medicineSlotsCount)
        {
            //let edit = editAction(at:indexPath)
            let delete = deleteAction(at:indexPath)
            return UISwipeActionsConfiguration(actions:[delete])
        }
        return nil
    }*/
    /*func editAction(at indexPath:IndexPath) -> UIContextualAction
    {
        let row = indexPath.row
        let action = UIContextualAction(style: .normal, title: "Edit Slot", handler: {
            (action,view,completion) in
            let alertController = UIAlertController(title: "Edit the slot for the record", message: "", preferredStyle: .alert)
            let slotSelected =
            
        })
    }*/
    /*func deleteAction(at indexPath:IndexPath) -> UIContextualAction
    {
        let row = indexPath.row
        let action = UIContextualAction(style: .destructive, title: "Delete", handler:{ (action,view,completion) in
            let alertController = UIAlertController(title:"Are you sure?", message:"You will lose the data forever.", preferredStyle: .alert)
            let alertAction_yes = UIAlertAction(title: "Yes", style: .destructive, handler: {
                (action) -> Void in
                try! self.realm.write {
                    self.realm.delete(self.records[row])
                }
                 self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
                alertController.addAction(alertAction_yes)
                alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                completion(true)
        })
        action.backgroundColor = UIColor.red
        return action
    }*/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        record = records[row]
        performSegue(withIdentifier: "ShowRecordSegue" , sender: nil)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let alertController = UIAlertController(title:"Are you sure?", message:"You will lose the data forever.", preferredStyle: .alert)
            let alertAction_yes = UIAlertAction(title: "Yes", style: .destructive, handler: {
                (action) -> Void in
                try! self.realm.write {
                    self.realm.delete(self.records[row])
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            
            alertController.addAction(alertAction_yes)
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        //else if(editingStyle == UITableViewCellEditingStyle.)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cell = tableView.dequeueReusableCell(withIdentifier: "LogViewCell", for: indexPath) as! LogViewCell
        var calendar = Calendar.current
        var record = records[row]
        slotID = record.medicineslotID
        let results_medicineSlot:MedicineSlot? = realm.object(ofType: MedicineSlot.self, forPrimaryKey: slotID)
        if let results_medicineSlot = results_medicineSlot
        {
            medicineslot = results_medicineSlot
            
        }
        else
        {
            medicineslot = MedicineSlot(timeofDay: record.medicineslotID, ErrorTime: 30)
        }
        let maxLimit = medicineslot.AcceptableErrorTime*2
        //print(row,medicineslot.IdealTime)
        //let IdealTimeList = [Int(medicineslot.timeofDay/60),Int(medicineslot.timeofDay%60)]
        var timedifference = UIMethods.getDifference(record.date!,medicineslot.timeofDay)
        if(timedifference>maxLimit)
        {
            cell.DeviationLabel.text = "Deviation: >" + String(maxLimit) + "Mins"
        }
        else
        {
            cell.DeviationLabel.text = "Deviation: " + String(timedifference) + "Mins"
        }
        //let IdealTimeofSlot = medicineslot.IdealTime
        cell.IdealTimeLabel.text = "Ideal Time: " + UIMethods.TimeinString(medicineslot.timeofDay)
        cell.DateLabel.text = UIMethods.stringOfDate(record.date!)
        let imageObj = realm.object(ofType: Image.self, forPrimaryKey: record.imageID)!
        cell.MedicinesImage.image =  UIImage(data:imageObj.imageData!)
        return cell
    }
    @IBAction func Refresh_TouchUpInside(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="ShowRecordSegue")
        {
            var destinationVC = segue.destination as! ShowPhotoViewController
            destinationVC.record = self.record
        }
    }
}
