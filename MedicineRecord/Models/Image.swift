//
//  Image.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/29/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import RealmSwift

class Image:Object
{
    @objc dynamic var imageData:Data?
    @objc dynamic var imageID = UUID().uuidString
    convenience init(imageData:Data)
    {
        self.init()
        self.imageData = imageData
    }
    override static func primaryKey() -> String
    {
        return "imageID"
    }
}
