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
    let timings = ["","15Mins","30Mins","45Mins","60Mins",">60Min"]
    //var barLabels_Morning:[String] = []
    //var barLabel_Night:[String] = []
    var dates:[String] = [""] //These are X labels
    var morning:Results<Record>! //All records with slots between the times given as input.
    var night:Results<Record>! //All records with slots between the times given as input.
    var chtChart:BarChartView!
    var noData = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        morning = GetRecords.getRecordsinTimeInterval([8,0], [11,0])
        night = GetRecords.getRecordsinTimeInterval([20,0], [23,0])
        //chtChart.noDataText = "No Data Available"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        // Dispose of any resources that can be recreated.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        StartingRealmMethods.addEntriestoRealm()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if(row==0)
        {
            return CGFloat(44)
        }
        return CGFloat(325)
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
        else if(row == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlotGraphViewCell", for: indexPath) as! SlotGraphViewCell
            cell.label.text = "Morning"
            chtChart = cell.chtChart
            //draw the chart
            updateGraph(morning)
            return cell
        }
            //Will enter if row = 2
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlotGraphViewCell", for: indexPath) as! SlotGraphViewCell
            cell.label.text = "Night"
            chtChart = cell.chtChart
            //draw the chart
            updateGraph(night)
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
        dates = [""]
        //barLabels = [""]
        var barChartEntry  = [BarChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //here is the for loop
        var colors:[NSUIColor] = []
        var xValue:Double = 1
        for i in 0..<records!.count {
            dates.append(UIMethods.stringOfOnlyDate(records![i].date!))
            //barLabels.append(UIMethods.stringOfOnlyTime(records[i].date!))
            let tempslot = realm.object(ofType: MedicineSlot.self, forPrimaryKey: records![i].medicineslotID)!
            let temp = UIMethods.getDifference(records![i].date!,tempslot.IdealTime)
            var yValue = Double(temp)/15.0
            if(temp>2*tempslot.AcceptableErrorTime)
            {
                yValue = Double(5)
            }
            if(showGreenBars==0 && temp<=tempslot.AcceptableErrorTime)
            {
                continue;
            }
            let value = BarChartDataEntry.init(x: xValue, y: yValue)// here we set the X and Y status in a data chart entry
            //incrementing xValue
            xValue = xValue+1
            if(temp>60)
            {
                colors.append(NSUIColor.red)
            }
            else if(temp>30)
            {
                colors.append(NSUIColor.yellow)
            }
            else
            {
                colors.append(NSUIColor.green)
            }
            //print(value)
            barChartEntry.append(value) // here we add it to the data set
        }
        if(barChartEntry.count==0)
        {
            chtChart.data = nil
            
            //We need to show dates and the size of dates is records!.count+1 because we add an empty string in the beginning.
            chtChart.noDataText = "All tablets taken on time between " + dates[1] + " and " + dates[records!.count]
            return
        }
        let barChartDataSet = BarChartDataSet.init(values: barChartEntry, label: "Deviation")
        barChartDataSet.colors = colors
        let chartData = BarChartData()
        chartData.addDataSet(barChartDataSet)
        chartData.setDrawValues(true)
        //chartData.barWidth=0.9
        chartData.setValueFormatter(DefaultValueFormatter(block:stringforValue))
        
        chtChart.data = chartData
        setChartStyle(chtChart)
    }
    func setChartStyle(_ chtChart:BarChartView)->Void
    {
        
        chtChart.chartDescription?.enabled = false
        chtChart.accessibilityScroll(.down)
        chtChart.noDataText = "No data available."
        
        //Disable top scrolling
        
        chtChart.xAxis.drawGridLinesEnabled = false
        chtChart.xAxis.labelPosition = .bottom
        chtChart.xAxis.granularity = 1
        
        //Try to remove this by adding minimum spacing between labels
        chtChart.setVisibleXRange(minXRange: 5, maxXRange: 5)
        //chtChart.moveViewToX(10)
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
        let c:CGFloat = CGFloat.nan
        let greenLegendEntry = LegendEntry.init(label: "Green: <30min, Yellow: 30-60min, Red: >60min", form: .square, formSize:CGFloat(0), formLineWidth: c, formLineDashPhase: c, formLineDashLengths: nil, formColor: NSUIColor.green)
        l.setCustom(entries: [greenLegendEntry])
    }
    func stringforValue(_ value: Double,_ entry: ChartDataEntry,_ dataSetIndex: Int,_ viewPortHandler: ViewPortHandler?) -> String
    {
        if(entry.y==5)
        {
            return ">60"
        }
        return String(entry.y*15)
    }
    @IBAction func RefreshGraph(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
}
//Tableview methods
extension GraphViewController:ShowFiltersCellDelegate
{
    func HideGreenBarsButton_TouchUpInside(_ cell:UITableViewCell,_ HideGreenBarsButton:UIButton)
    {
        print("1")
        showGreenBars = 1 - showGreenBars
        print("2")
        tableView.reloadSections([0], with: .automatic)
    }
}
