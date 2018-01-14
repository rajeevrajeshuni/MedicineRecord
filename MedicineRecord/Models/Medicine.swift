//
//  Medicine.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/5/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import RealmSwift
class Medicine:Object{
    @objc dynamic var name:String = ""
    @objc dynamic var dosage:String = ""
    @objc dynamic var MedicineID = UUID().uuidString
    
    convenience init(name:String,dosage:String)
    {
        self.init()
        self.name = name
        self.dosage = dosage
    }
    
    override static func primaryKey()->String
    {
        return "MedicineID"
    }
}
