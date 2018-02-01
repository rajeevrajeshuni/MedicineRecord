//
//  ConfirmImageViewController.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 12/26/17.
//  Copyright © 2017 Rajeev Rajeshuni. All rights reserved.
//

import UIKit
import Photos
import Foundation
import RealmSwift

class ConfirmImageViewController: UIViewController {
    var image:UIImage!
    let albumName = "Tablets"
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var SlotNameLabel: UILabel!
    var SlotSelected:Int!
    var realm = try! Realm()
    var user:User?
    var medicineslots:Results<MedicineSlot>!
    var records:Results<Record>!
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
        user = User.defaultUser(realm)
        medicineslots = realm.objects(MedicineSlot.self).sorted(byKeyPath: "timeofDay", ascending: true)
        SlotSelected = selectSlot(medicineslots)
        if(SlotSelected == -1)
        {
            SlotNameLabel.text = "Select"
        }
        else
        {
            SlotNameLabel.text = UIMethods.TimeinString(medicineslots[SlotSelected].timeofDay)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //photo.image = self.image
    }

    @IBAction func CancelButton_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func SaveButton_TouchUpInside(_ sender: Any) {
        let compressedImageDate = UIImageJPEGRepresentation(image,CGFloat(0.1))!
        image = UIImage(data: compressedImageDate)!
        
        let isSaved = saveinDatabase()
        if(isSaved)
        {
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func SlotChangeButton_TouchUpInside(_ sender: Any) {
        let alert = UIAlertController(title:nil,message:nil,preferredStyle: .actionSheet)
        /*alert.addAction(UIAlertAction.init(title: "Select", style: .default, handler: {
            (action) -> Void in
            self.SlotNameLabel.text = "Select"
            self.SlotSelected = -1
        }))*/
        for i in 0..<medicineslots.count{
            let slotString:String = UIMethods.TimeinString(medicineslots[i].timeofDay)
            /*if(i==SlotSelected)
            {
                 alert.addAction(UIAlertAction(title:"Selected - "+slotString,style: .destructive,handler:nil))
                continue;
            }*/
            alert.addAction(UIAlertAction(title:slotString,style: .default,handler: {
                (action) -> Void in
                self.SlotNameLabel.text = slotString
                self.SlotSelected = i
            }))
        }
        alert.addAction(UIAlertAction(title:"Cancel",style: .cancel,handler:nil))
        present(alert,animated: true,completion: nil)
    }
    func saveinDatabase() -> Bool
    {
        //Backup in Camera Roll
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        if(SlotSelected == -1)
        {
            showAlert(with: "Select a Medicine Slot.")
            //Save UnSuccessful
            return false
        }
        else
        {
            let imagedata:Data = UIImageJPEGRepresentation(image, 0.1)! as Data
            let medicineslot = medicineslots[SlotSelected]
            let date = Date()
            let user = User.defaultUser(realm)
            let imageObj = Image(imageData: imagedata)
            records = realm.objects(Record.self).filter("medicineslotID = %@",medicineslot.timeofDay).sorted(byKeyPath: "date", ascending: false)
            if(records.count>0)
            {
                print("Dishum")
                let topRecordsDateComponents = Calendar.current.dateComponents([.day,.month,.year], from: records[0].date!)
                let currentDateComponents = Calendar.current.dateComponents([.day,.month,.year], from:date)
                if(topRecordsDateComponents.day!==currentDateComponents.day! && topRecordsDateComponents.month!==currentDateComponents.month! && topRecordsDateComponents.year!==currentDateComponents.year!)
                {
                    showAlert(with:"You already took medicines for the selected Medicine Slot.")
                    return false
                }
            }
            let record = Record(medicineslotID: medicineslot.timeofDay, user: user, imageID:imageObj.imageID, date: date)
            try! realm.write {
                realm.add(imageObj)
                realm.add(record)
            }
            //Save Successful
            return true
        }
    }
    func showAlert(with text:String){
        let alert = UIAlertController(title:text,message:"",preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    func writePhoto(_ image:UIImage)
    {
        UIImageWriteToSavedPhotosAlbum(image,nil, nil,nil)
        var compressedImgData:Data = UIImageJPEGRepresentation(image,0.1)! as Data
        print("Image size in KB:")
        print(Double(compressedImgData.count)/1024.0)
        let compressedImage = UIImage(data:compressedImgData)!
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format:"title = %@",albumName)
        let fetchResult: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options:fetchOptions)
         print("Album fetched")
         if let tabletImageCollection = fetchResult.firstObject{
                PHPhotoLibrary.shared().performChanges({
                // Request creating an asset from the image.
                let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: compressedImage)
                // Request editing the album.
                guard let addAssetRequest = PHAssetCollectionChangeRequest(for: tabletImageCollection)
                else { return }
                // Get a placeholder for the new asset and add it to the album editing request.
                addAssetRequest.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
                }, completionHandler: { success, error in
                if !success { NSLog("error creating asset: \(error)") }
                })
        }
    }
    func selectSlot(_ medicineslots:Results<MedicineSlot>) -> Int
    {
        var slot = -1;
        let date = Date()
        //print(medicineslots.count)
        for i in 0..<medicineslots.count
        {
            //print(UIMethods.getDifference(date, medicineslots[i].timeofDay),medicineslots[i].AcceptableErrorTime)
            if(UIMethods.getDifference(date, medicineslots[i].timeofDay)<medicineslots[i].AcceptableErrorTime)
            {
                slot = i;
                return slot;
            }
        }
        return slot
    }
}
