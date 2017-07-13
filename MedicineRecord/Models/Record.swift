//
//  Record.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/7/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import RealmSwift
class Record:Object
{
    @objc dynamic var medicineslotID:Int = 0
    @objc dynamic var user:User?
    @objc dynamic var imageID:String?
    @objc dynamic var RecordID = UUID().uuidString
    @objc dynamic var date:Date?
    //Number of minutes for the date from the start of the day. Actually this value is unneccesary. So remove it in the next version.
    @objc dynamic var timestamp:Double = 0
    convenience init(medicineslotID:Int,user:User,imageID:String,date:Date) {
        self.init()
        self.medicineslotID = medicineslotID
        self.user = user
        self.imageID = imageID
        self.date = date
        self.timestamp = date.timeIntervalSince1970
    }
    override static func primaryKey() -> String
    {
        return "RecordID"
    }
    @discardableResult
    static func isEmpty(in realm:Realm) -> Bool
    {
        let slot =  realm.objects(Record.self)
        if(slot.count==0)
        {
            return true
        }
        else
        {
            return false
        }
    }
}
