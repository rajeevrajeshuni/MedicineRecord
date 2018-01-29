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
    var slotID:String!
    var medicineslot:MedicineSlot!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Don't extract all at once for optimization
        records = realm.objects(Record.self).sorted(byKeyPath: "timestamp", ascending: false)
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
        return true
    }
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
                tableView.reloadData()
            })
            
            alertController.addAction(alertAction_yes)
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
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
        let results_medicineSlot:MedicineSlot = realm.object(ofType: MedicineSlot.self, forPrimaryKey: slotID)!
        medicineslot = results_medicineSlot
        let maxLimit = medicineslot.AcceptableErrorTime*2
        //print(row,medicineslot.IdealTime)
        var timedifference = UIMethods.getDifference(record.date!,medicineslot.IdealTime)
        if(timedifference>maxLimit)
        {
            cell.DeviationLabel.text = "Deviation: >" + String(maxLimit) + "Mins"
        }
        else
        {
            cell.DeviationLabel.text = "Deviation: " + String(timedifference) + "Mins"
        }
        let IdealTimeofSlot = medicineslot.IdealTime
        cell.IdealTimeLabel.text = UIMethods.stringofIdealTime(IdealTimeofSlot)
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
            var destinationVC = segue.destination as! ShowRecordViewController
            destinationVC.record = self.record
        }
    }
}
