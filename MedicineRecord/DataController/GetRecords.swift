//
//  getRecords.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/12/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import RealmSwift
class GetRecords
{
    static var realm = try! Realm()
    static var slots:Results<MedicineSlot>!
    //Will have the start time and end time in hrs,mins format in an array.
    /*static func getSlotsinTimeInterval(_ startTime:[Int],_ endTime:[Int]) -> [MedicineSlot]
    {
        slots = realm.objects(MedicineSlot.self)
        var slotsinTimeInterval:[MedicineSlot] = []
        let startTime_timeOfDay = startTime[0]*60+startTime[1]
        let endTime_timeOfDay = endTime[0]*60+endTime[1]
        for i in slots
        {
            let timeOfSlot = i.timeofDayinMinutes
            if(timeOfSlot>=startTime_timeOfDay && timeOfSlot<=endTime_timeOfDay)
            {
                slotsinTimeInterval.append(i)
            }
        }
        return slotsinTimeInterval
    }
    static func getRecordsinTimeInterval(_ startTime:[Int],_ endTime:[Int]) -> Results<Record>?
    {
        let slotsinTimeInterval = getSlotsinTimeInterval(startTime, endTime)
        if(slotsinTimeInterval.count==0)
        {
            return nil
        }
        var filterString:String = ""
        for i in 0..<slotsinTimeInterval.count
        {
            if(i == 0)
            {
                filterString = filterString + "medicineslotID = '" + slotsinTimeInterval[i].SlotID  + "'"
            }
            else
            {
                filterString = filterString + " OR medicineslotID = '" + slotsinTimeInterval[i].SlotID  + "'"
            }
        }
        //print(filterString)
        return realm.objects(Record.self).filter(filterString).sorted(byKeyPath:"date")
    }*/
}
