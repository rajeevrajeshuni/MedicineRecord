//
//  UIMethods.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/13/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class UIMethods {
    static func getDifference(_ date:Date,_ IdealTime:List<Int>, _ maxLimit:Int) -> Int
    {
        //var date = tdate
        //date.addTimeInterval(330*60)
        var diff = 0
        let calendar = Calendar.current
        let hourofRecord = calendar.component(.hour, from:date)
        let minuteofRecord = calendar.component(.minute, from: date)
        print(hourofRecord,minuteofRecord)
        let hourofSlot = IdealTime[0]
        let minuteofSlot = IdealTime[1]
        
        let timeOfDay_Record = hourofRecord*60 + minuteofRecord
        let timeOfDay_Slot = hourofSlot*60+minuteofRecord
        
        //case 1:
        if(hourofSlot*60+minuteofRecord<maxLimit)
        {
            //This will be at the start of the day
            if(hourofSlot<hourofRecord && hourofRecord<2*maxLimit)
            {
                diff = (hourofRecord*60+minuteofRecord) - (hourofSlot*60+minuteofSlot)
            }
            else
            {
                diff = (hourofSlot*60+minuteofSlot+1440)-(hourofRecord*60+minuteofRecord)
            }
            
        }
        else if(1440-maxLimit<(hourofSlot*60+minuteofSlot))
        {
            //This will be at the end of the day
            if(hourofSlot>hourofRecord)
            {
                diff = (hourofSlot*60+minuteofSlot) - (hourofRecord*60+minuteofRecord)
            }
            else
            {
                diff = (hourofRecord*60+minuteofRecord+1440) - (hourofSlot*60+minuteofSlot)
            }
        }
        else
        {
            if(hourofSlot*60+minuteofSlot>hourofRecord*60+minuteofRecord)
            {
                diff = (hourofSlot*60+minuteofSlot) - (hourofRecord*60+minuteofRecord)
            }
            else
            {
                diff = (hourofRecord*60+minuteofRecord) - (hourofSlot*60+minuteofSlot)
            }
        }
        return diff
    }
    
    static func stringOfDate(_ date:Date) -> String
    {
        return stringOfOnlyDate(date) + " - " + stringOfOnlyTime(date)
    }
    static func stringOfOnlyDate(_ date:Date) -> String
    {
        let calendar = Calendar.current
        var dayofRecord = String(calendar.component(.day, from: date))
        var monthofRecord = String(calendar.component(.month, from: date))
        var yearofRecord = String(calendar.component(.year, from: date)%100)
        
        if(monthofRecord.count==1)
        {
            monthofRecord = "0" + monthofRecord
        }
        if(dayofRecord.count==1)
        {
            dayofRecord = "0" + dayofRecord
        }
        let onlydate = dayofRecord + "/" + monthofRecord + "/" + yearofRecord
       // let onlytime = hourofRecord + ":" + minuteofRecord + "Hrs"
        return onlydate
    }
    static func stringOfOnlyTime(_ date:Date) -> String
    {
        let calendar = Calendar.current
        var hourofRecord = String(calendar.component(.hour, from:date))
        var minuteofRecord = String(calendar.component(.minute, from: date))
        
        if(hourofRecord.count==1)
        {
            hourofRecord = "0" + hourofRecord
        }
        if(minuteofRecord.count==1)
        {
            minuteofRecord = "0" + minuteofRecord
        }
        //let onlydate = dayofRecord + "/" + monthofRecord + "/" + yearofRecord
        let onlytime = hourofRecord + ":" + minuteofRecord + "Hrs"
        return onlytime
    }
    static func stringofIdealTime(_ idealTime:List<Int>) -> String
    {
        var hour = String(idealTime[0])
        var minute = String(idealTime[1])
        if(hour.count==1)
        {
            hour = "0" + hour
        }
        if(minute.count==1)
        {
            minute = "0" + minute
        }
        return "Ideal Time: " + hour + ":" + minute + "Hrs"
    }
}
