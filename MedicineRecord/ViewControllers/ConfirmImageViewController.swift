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
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
        user = User.defaultUser(realm)
        medicineslots = realm.objects(MedicineSlot.self).filter("current = %@",1)
        SlotNameLabel.text = "Select"
        SlotSelected = -1
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
        let alert = UIAlertController(title:"Select a Medicine Slot",message:"",preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction.init(title: "Select", style: .default, handler: {
            (action) -> Void in
            self.SlotNameLabel.text = "Select"
            self.SlotSelected = -1
        }))
        for i in 0..<medicineslots.count{
            alert.addAction(UIAlertAction(title:medicineslots[i].SlotName,style: .default,handler: {
                (action) -> Void in
                self.SlotNameLabel.text = self.medicineslots[i].SlotName
                self.SlotSelected = i
            }))
        }
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
            let record = Record(medicineslotID: medicineslot.SlotID, user: user, imageID:imageObj.imageID, date: date)
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
}
