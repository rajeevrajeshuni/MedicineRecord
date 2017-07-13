//
//  User.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/5/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import RealmSwift

class User:Object{
    convenience init(username:String){
        self.init()
        self.username = username
    }
   //@objc dynamic var UserID = UUID().uuidString
 //  @objc dynamic var timezone:TimeZone = TimeZone.current
   @objc dynamic var username:String? //Must be unique and should be set by the user
    
    override static func primaryKey() -> String
    {
        return "username"
    }
    
    private static func createDefaultUser(in realm:Realm) -> User
    {
        let user = User(username:"defaultUser")
        try! realm.write
        {
            realm.add(user)
        }
        return user
        
    }
    @discardableResult
    static func defaultUser(_ realm:Realm) -> User
    {
        return realm.object(ofType: User.self, forPrimaryKey: "defaultUser") ?? createDefaultUser(in:realm)
    }
}
