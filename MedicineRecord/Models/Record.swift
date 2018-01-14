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
    @objc dynamic var medicineslotID:String?
    @objc dynamic var user:User?
    @objc dynamic var imageData:Data?
    @objc dynamic var RecordID = UUID().uuidString
    @objc dynamic var date:Date?
    @objc dynamic var timestamp:Double = 0
    convenience init(medicineslotID:String,user:User,imageData:Data,date:Date) {
        self.init()
        self.medicineslotID = medicineslotID
        self.user = user
        self.imageData = imageData
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
