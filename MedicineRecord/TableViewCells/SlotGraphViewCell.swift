//
//  SlotView.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 1/4/18.
//  Copyright © 2018 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import UIKit
import Charts
class SlotGraphViewCell:UITableViewCell{
    //static let reuseIdentifier = "SlotView"
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var chtChart: BarChartView!
    @IBOutlet weak var accuracyLabel: UILabel!
}
