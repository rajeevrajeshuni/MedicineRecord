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
    
    convenience init(timeofDay:Int, ErrorTime:Int)
    {
        self.init()
        self.timeofDay = timeofDay
        self.AcceptableErrorTime = ErrorTime
    }
     //These values should be set by the user in settings.
    //var Medicines = RealmSwift.List<Medicine>()
    @objc dynamic var AcceptableErrorTime:Int = 0 //value denotes time in minutes.
    //Sepcifies if the medicine slot is currently used or an old one. It's important to keep the old slots because we still need to maintain the old records even if the meds changed.
    @objc dynamic var timeofDay:Int = 0
    
    override static func primaryKey() -> String{
        return "timeofDay"
    }
    
    @discardableResult
    func TimeinString()->String
    {
        var time = [0,0]
        time[0] = Int(timeofDay/60)
        time[1] = timeofDay%60
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
