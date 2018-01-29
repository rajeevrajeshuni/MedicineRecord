//
//  Notifications.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/28/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

//This class will include the functionality for the creating new and deleting old notifications.
import Foundation
import UserNotifications
import RealmSwift
class Notifications
{
    //Deletes all the Notifications prior to(including the given) the given date.
    //Delete all the Notifications for the given slot on that day.
    //Done after the medicine intake is recorded on a day for a slot.
    static func deleteNotifications(forSlot slotID:String,forDate date:Date)
    {
        let realm = try! Realm()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        var medicineSlot = realm.object(ofType: MedicineSlot.self, forPrimaryKey: slotID)! as MedicineSlot
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler:{requests -> () in
            //Delete this code later.
            print("\(requests.count) requests -------")
            for request in requests{
                let trigger = request.trigger as! UNCalendarNotificationTrigger
                print(request.identifier,request.content,trigger.nextTriggerDate(),trigger.dateComponents)
            }
        })
    }
    //Create the new notifications so that there will always be notifications for 15 days.
    static func createNotifications()
    {
        //Should also handle the case where there are no old notifications. Happens at the beginning of the app.
        //Delete this code later.
        let date = Date()
        var dateComponents = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: date)
        dateComponents.hour = 1
        var newdate = Calendar.current.date(from: dateComponents)!
        for i in 0..<15
        {
            let content = UNMutableNotificationContent()
            content.title = "Test Title"
            content.body = "Test body"
            content.sound = UNNotificationSound.default()
            newdate = Calendar.current.date(byAdding: .day, value: 1, to: newdate)!
            let dateComponents = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: newdate)
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
            let notificationRequest = UNNotificationRequest(identifier: UIMethods.stringOfDate(newdate), content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: {
                (error) in
                if let error = error{
                    print(error)
                }
            })
        }
    }
}
