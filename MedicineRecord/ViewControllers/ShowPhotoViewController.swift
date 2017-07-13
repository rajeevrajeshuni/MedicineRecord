//
//  ShowRecordViewController.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/10/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
class ShowPhotoViewController:UIViewController{
    var record:Record!
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        //let slotID = record.medicineslotID
        //let medicineslot = realm.object(ofType: MedicineSlot.self, forPrimaryKey: slotID)!
        let imageObj = realm.object(ofType: Image.self, forPrimaryKey: record.imageID!)!
        RecordImageView.image = UIImage(data:imageObj.imageData!)
    }
    @IBOutlet weak var RecordImageView: UIImageView!
    /*func getMedicinestext(_ medicines:RealmSwift.List<Medicine>) -> String
    {
        var string = "Medicines: "
        for i in 0..<medicines.count{
            
            if(i==0)
            {
                string = string + medicines[i].name + " " + medicines[i].dosage
            }
            else
            {
                string = string + "," + medicines[i].name + " " + medicines[i].dosage
            }
        }
        return string
    }*/
}
