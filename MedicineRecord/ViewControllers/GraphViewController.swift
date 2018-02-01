//
//  SecondViewController.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 12/23/17.
//  Copyright © 2017 Rajeev Rajeshuni. All rights reserved.
//

import UIKit
import Photos
import Charts
import RealmSwift
class GraphViewController: UITableViewController {
    var showGreenBars = 1
    let realm = try! Realm()
    //Fix these timings in the next version.
    var timings = ["0min","","","","Missed"]
    var dates:[String] = [""] //These are X labels
    var slotRecords:Results<Record>!
    //var morning:Results<Record>! //All records with slots between the times given as input.
    //var night:Results<Record>! //All records with slots between the times given as input.
    var chtChart:BarChartView!
    var noData = 0
    var AcceptableErrorTime = 0
    var medicineSlots:Results<MedicineSlot>!
    var accuracy:Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print(Date())
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        medicineSlots = realm.objects(MedicineSlot.self).sorted(byKeyPath: "timeofDay", ascending: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        // Dispose of any resources that can be recreated.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //StartingRealmMethods.addEntriestoRealm()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + medicineSlots.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if(row==0)
        {
            return CGFloat(44)
        }
        return CGFloat(375)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = indexPath.row
        if(row==0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowFiltersCell", for: indexPath) as! ShowFiltersCell
            cell.delegate = self
            let button = cell.HideGreenBarsButton!
            if(showGreenBars==1)
            {
                button.setTitle("Hide Green Bars", for: .normal)
            }
            else
            {
                button.setTitle("Show Green Bars", for: .normal)
            }
            return cell
        }
        else
        {
            let i = row - 1
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlotGraphViewCell", for: indexPath) as! SlotGraphViewCell
            cell.label.text = UIMethods.TimeinString(medicineSlots[i].timeofDay) + " - " + String(medicineSlots[i].AcceptableErrorTime) + "min"
            chtChart = cell.chtChart
            slotRecords = realm.objects(Record.self).filter("medicineslotID = %@",medicineSlots[i].timeofDay)
            //draw the chart
            updateGraph(slotRecords)
            //accuracy = 0.960555
            accuracy = Double(Int(accuracy*1000))/1000 //Converting accuracy to required format.
            cell.accuracyLabel.text = "Accuracy: " + String(accuracy*100) + "%"
            return cell
        }
    }
    func updateGraph(_ records:Results<Record>?)
    {
        //chtChart.noDataText = "No Data Available"
        if(records==nil || noData==1 || records!.count==0)
        {
            return
        }
        let medicineslot = getmedicineslot(forRecord:records![0])
        self.AcceptableErrorTime = medicineslot.AcceptableErrorTime
        setYlabels(medicineslot.AcceptableErrorTime)
        dates = [""]
        //barLabels = [""]
        var barChartEntry  = [BarChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //here is the for loop
        var colors:[NSUIColor] = []
        var xValue:Double = 1
        let startDate = records![0].date!
        let endDate_String = UIMethods.stringOfOnlyDate(getendDate_Chart(records![records!.count-1])) //get the end date.
        var i = 0
        var tempdate = startDate
        while(true)
        {
            let tempdate_string = UIMethods.stringOfOnlyDate(tempdate)
            
            //If this if condition is true then the entry for that particular day is completely missing.
            if(i>=records!.count || (UIMethods.stringOfOnlyDate(records![i].date!) != tempdate_string))
            {
                dates.append(tempdate_string)
                let value = BarChartDataEntry.init(x: xValue, y: 4.0) // Tablet is missed
                colors.append(NSUIColor.purple)
                xValue = xValue+1
                barChartEntry.append(value)
                if(tempdate_string == endDate_String)
                {
                    break;
                }
                tempdate = Calendar.current.date(byAdding: .day, value: 1, to: tempdate)!
                continue
            }
            
            //barLabels.append(UIMethods.stringOfOnlyTime(records[i].date!))
            let temp = UIMethods.getDifference(records![i].date!,medicineslot.timeofDay)
            
            if(showGreenBars == 0 && temp <= medicineslot.AcceptableErrorTime)
            {
                //print("*",tempdate_string,i,showGreenBars,temp,medicineslot.AcceptableErrorTime)
                i = i+1
                if(tempdate_string == endDate_String)
                {
                    break;
                }
                tempdate = Calendar.current.date(byAdding:.day, value:1, to:tempdate)!
                continue;
            }
            
            dates.append(tempdate_string)
            var yValue = Double(temp)/Double(medicineslot.AcceptableErrorTime)
            
            //Assigns for values of > AccetableErrorTime
            if(temp>medicineslot.AcceptableErrorTime)
            {
                yValue = Double(3) //Tablet is taken but outside the acceptable Error Time.
            }
            else
            {
                yValue = 2*yValue
            }
            
            let value = BarChartDataEntry.init(x: xValue, y: yValue)// here we set the X and Y status in a data chart entry
            //incrementing xValue
            xValue = xValue+1
            if(temp>medicineslot.AcceptableErrorTime)
            {
                colors.append(NSUIColor.red)
            }
            else
            {
                colors.append(NSUIColor.green)
            }
            //print(value)
            barChartEntry.append(value) // here we add it to the data set
            i = i+1
            if(tempdate_string == endDate_String)
            {
                break;
            }
            tempdate = Calendar.current.date(byAdding: .day, value: 1, to: tempdate)!
        }
        if(barChartEntry.count==0)
        {
            chtChart.data = nil
            
            //We need to show dates and the size of dates is records!.count+1 because we add an empty string in the beginning.
            chtChart.noDataText = "All tablets taken on time between " + UIMethods.stringOfOnlyDate(startDate) + " and " + endDate_String
            return
        }
        var countInTime = 0 //Count for number of tablets taken with in acceptable Error Time
        for i in 0..<barChartEntry.count
        {
            if(barChartEntry[i].y<3)
            {
                countInTime = countInTime + 1
            }
        }
        accuracy = Double(countInTime)/Double(barChartEntry.count)
        let barChartDataSet = BarChartDataSet.init(values: barChartEntry, label: "Deviation")
        barChartDataSet.colors = colors
        let chartData = BarChartData()
        chartData.addDataSet(barChartDataSet)
        chartData.setDrawValues(true)
        //chartData.barWidth=0.9
        chartData.setValueFormatter(DefaultValueFormatter(block:stringforValue))
        
        chtChart.data = chartData
        setChartStyle(chtChart,medicineslot.AcceptableErrorTime)
    }
    func setChartStyle(_ chtChart:BarChartView,_ AcceptableErrorTime:Int)
    {
        chtChart.highlightPerTapEnabled = false
        chtChart.doubleTapToZoomEnabled = false
        chtChart.chartDescription?.enabled = false
        chtChart.accessibilityScroll(.down)
        chtChart.noDataText = "No data available."
        
        //Disable top scrolling
        
        
        
        chtChart.xAxis.drawGridLinesEnabled = false
        chtChart.xAxis.labelPosition = .bottom
        chtChart.xAxis.granularity = 1
        
        //Try to remove this by adding minimum spacing between labels
        chtChart.setVisibleXRangeMaximum(5.0)
        
        //Move the X axis to a specific point.
        if(dates.count>3)
        {
            chtChart.moveViewToX(Double(dates.count)-3)
        }
        chtChart.xAxis.axisMinimum = 0
        //dates = loadDates()
        chtChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:dates)
        
        
        
        chtChart.leftAxis.drawGridLinesEnabled = false
        chtChart.leftAxis.gridColor = NSUIColor.purple
        chtChart.leftAxis.axisMinimum = 0
        chtChart.leftAxis.granularity = 1
        chtChart.leftAxis.valueFormatter = IndexAxisValueFormatter(values:timings)
        chtChart.rightAxis.drawGridLinesEnabled = false
        chtChart.rightAxis.enabled = false
        
        
        let Yrange = 6.0;
        chtChart.setVisibleYRangeMaximum(Yrange, axis: .left)
        chtChart.setVisibleYRangeMinimum(Yrange, axis: .left)
        chtChart.dragYEnabled = false //Why is this not working?
        
        let l = chtChart.legend
        l.enabled = false
        /*let c:CGFloat = CGFloat.nan
        let legendString = "Green: <" + String(AcceptableErrorTime) + "min, Red: >" + String(2*AcceptableErrorTime) + "min, Purple: Missed Medicine"
        let customLegendEntry = LegendEntry.init(label: legendString, form: .square, formSize:CGFloat(0), formLineWidth: c, formLineDashPhase: c, formLineDashLengths: nil, formColor: NSUIColor.green)
        l.setCustom(entries: [customLegendEntry])*/
        
    }
    // We receive the last record in the Results from the realm.
    func getendDate_Chart(_ record:Record) -> Date
    {
        let slotID = record.medicineslotID
        let lastRecordDate = record.date!
        let date = Date()
        let calendar = Calendar.current
        
        
        //If there is already a record for the current date.
        if(UIMethods.stringOfOnlyDate(lastRecordDate) == UIMethods.stringOfOnlyDate(date))
        {
            return date
        }
        
        
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let timeofDay = hour*60+minute
        let medicineslot = realm.object(ofType: MedicineSlot.self, forPrimaryKey: slotID)!
        //Checking whether medicines time has passed for the current day.
        if(timeofDay > medicineslot.timeofDay + medicineslot.AcceptableErrorTime)
        {
            return date
        }
        else
        {
            //return previosu day of the current date.
            return calendar.date(byAdding: .day, value: -1, to: date)!
        }
    }
    func stringforValue(_ value: Double,_ entry: ChartDataEntry,_ dataSetIndex: Int,_ viewPortHandler: ViewPortHandler?) -> String
    {
        if(entry.y==4)
        {
            return "Missed"
        }
        if(entry.y==3)
        {
            return ">" + String(AcceptableErrorTime) + "min"
        }
        return String(entry.y*Double(AcceptableErrorTime/2))
    }
    @IBAction func RefreshGraph(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
    func setYlabels(_ AcceptableErrorTime:Int)
    {
        timings[1] = String(AcceptableErrorTime/2) + "min"
        timings[2] = String(AcceptableErrorTime) + "min"
        timings[3] = ">" + timings[2]
    }
    func getmedicineslot(forRecord record:Record) -> MedicineSlot
    {
        let slotID = record.medicineslotID
        return realm.object(ofType: MedicineSlot.self, forPrimaryKey: slotID)!
    }
}
//Tableview methods
extension GraphViewController:ShowFiltersCellDelegate
{
    func HideGreenBarsButton_TouchUpInside(_ cell:UITableViewCell,_ HideGreenBarsButton:UIButton)
    {
        //print("1")
        showGreenBars = 1 - showGreenBars
        //print("2")
        tableView.reloadSections([0], with: .automatic)
    }
}
