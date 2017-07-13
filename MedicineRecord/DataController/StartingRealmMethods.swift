//
//  StartingRealmMethods.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/13/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import Photos
import RealmSwift

class StartingRealmMethods
{
    static let realm = try! Realm()
    /*static func addEntriestoRealm()
    {
        //getslotID's
        let slotIDs = realm.objects(MedicineSlot.self)
        //print(slotIDs)
        let calendar = Calendar.current
        var hourofRecord = 0
        var minuteofRecord = 0
        let medicineSlotsAvailable = MedicineSlot.isEmpty(in: realm)
        if(medicineSlotsAvailable)
        {
           print("Add Medicine Slots to record medicine intake.")
           return
        }
        if(UserDefaults.standard.bool(forKey: "PhotosAdded")==false)
        {
            UserDefaults.standard.set(true, forKey: "PhotosAdded")
            let albumName = "Tablets"
            var timings = [Date?]()
            let fetchOptions = PHFetchOptions()
            var medicineslotID = ""
            var record:Record!
            fetchOptions.predicate = NSPredicate(format:"title = %@",albumName)
            let fetchResult: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options:fetchOptions)
            var medicineslots = realm.objects(MedicineSlot.self).filter("current = %@",1).sorted(byKeyPath: "timeofDayinMinutes", ascending: true)
            
            if let tabletImageCollection = fetchResult.firstObject{
                let fetchImages:PHFetchResult = PHAsset.fetchAssets(in: tabletImageCollection, options: nil)
                let imageCount = fetchImages.count
                var tempImage = PHAsset();
                for i in 0..<imageCount{
                    tempImage = fetchImages.object(at: i) as PHAsset
                    hourofRecord = calendar.component(.hour, from:tempImage.creationDate!)
                    minuteofRecord = calendar.component(.minute, from:tempImage.creationDate!)
                    if(hourofRecord<3 || hourofRecord>=15)
                    {
                        medicineslotID = medicineslots[1].SlotID
                        print(UIMethods.stringOfDate(tempImage.creationDate!),"Night",medicineslotID)
                    }
                    else
                    {
                        medicineslotID = medicineslots[0].SlotID
                        print(UIMethods.stringOfDate(tempImage.creationDate!),"Morning",medicineslotID)
                    }
                    let imagedata:Data = UIImageJPEGRepresentation(getImagefromAsset(tempImage), 0.1)! as Data
                    record = Record.init(medicineslotID: medicineslotID, user: User.defaultUser(realm), imageData:imagedata, date: tempImage.creationDate!)
                    try! realm.write {
                        //realm.add(record)
                    }
                    //Add deleted photos
                }
            }
            else{
                print("No such album exists")
            }
        }
    }
    static func getImagefromAsset(_ asset:PHAsset) -> UIImage
    {
        let manager = PHImageManager.default()
        var options: PHImageRequestOptions?
        var image:UIImage!
        options = PHImageRequestOptions()
        options?.resizeMode = .exact
        options?.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options,resultHandler: {(result, info)->Void in
             image = result!
        })
        return image
    }*/
}
