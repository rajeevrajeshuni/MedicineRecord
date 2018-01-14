//
//  Slot.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/5/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import RealmSwift

class MedicineSlot:Object{
    
    convenience init(IdealTime:RealmSwift.List<Int>,Medicines:RealmSwift.List<Medicine>, SlotName:String, ErrorTime:Int)
    {
        self.init()
        self.IdealTime = IdealTime
        self.Medicines = Medicines
        self.SlotName = SlotName
        self.AcceptableErrorTime = ErrorTime
        self.timeofDayinMinutes = self.IdealTime[0]*60 + self.IdealTime[1]
    }
    
     //These values should be set by the user in settings.
    var IdealTime = RealmSwift.List<Int>()  //value in index 0 denotes the hour and index 1 denotes the minutes in 24hr format.
    var Medicines = RealmSwift.List<Medicine>()
    @objc dynamic var SlotName:String = "Medicine" //Must be unique
    @objc dynamic var AcceptableErrorTime:Int = 0 //value denotes time in minutes.
    @objc dynamic var SlotID = UUID().uuidString
    //Sepcifies if the medicine slot is currently used or an old one. It's important to keep the old slots because we still need to maintain the old records even if the meds changed.
    @objc dynamic var current = 1
    @objc dynamic var timeofDayinMinutes:Int = 0
    
    override static func primaryKey() -> String{
        return "SlotID"
    }
    
    @discardableResult
    func TimeinString()->String
    {
        let time = self.IdealTime
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
    @discardableResult
    static func isEmpty(in realm:Realm) -> Bool
    {
        let slot =  realm.objects(MedicineSlot.self)
        if(slot.count==0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    /*override static func indexedProperties() -> [String]{
        return [""]
    }*/
}
