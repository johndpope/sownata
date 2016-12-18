//
//  ViewController.swift
//  sownata
//
//  Created by Gary Joy on 19/04/2016.
//
//

import UIKit

import Charts


class DashboardViewController: UIViewController {

    var months: [String]!
    
    var dataSet: BarChartDataSet!

//    func setChart(xValues: [String], dataPoints: [String], values: [Double], moreValues: [Double]) {
//        barChartView.noDataText = "You need to provide data for the chart."
//        
//        var dataEntries: [BarChartDataEntry] = []
////        var dataEntries2: [BarChartDataEntry] = []
//        
//        for i in 0..<dataPoints.count {
//            let dataEntry = BarChartDataEntry(x: xValues[i], yValues: [values[i]])
//            dataEntries.append(dataEntry)
////            let dataEntry2 = BarChartDataEntry(value: moreValues[i], xIndex: i)
////            dataEntries2.append(dataEntry2)
//        }
//        
//        let chartDataSet = BarChartDataSet(values: dataEntries, label: nil)
//        chartDataSet.colors = [ UIColor.purple, UIColor.orange ]
//        chartDataSet.stackLabels = ["Likes","Posts"]
//
////        let chartDataSet2 = BarChartDataSet(yVals: dataEntries2, label: "Units Returned")
////        chartDataSet2.colors = [ UIColor.orangeColor() ]
//
//        let chartData = BarChartData(dataSet: chartDataSet)
//        barChartView.data = chartData
//        
//        barChartView.chartDescription?.text = ""
//        
//        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
//        
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.current.orientation.isLandscape {
            print("Landscape (Dashboard)")
        }
        else if UIDevice.current.orientation.isPortrait {
            print("Portrait (Dashboard)")
            _ = navigationController?.popViewController(animated: true)
            self.navigationController?.isNavigationBarHidden = false;
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    
    override func viewDidLoad() {
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationController?.isNavigationBarHidden = true;
        
        barChartView.noDataText = "???"
        
//        months = ["Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar"]
//        let unitsSold = [4.0,1.0,2.0,1.0,3.0,3.0,1.0,1.0,2.0,1.0,6.0,3.0,4.0] //like
//        let unitsReturned = [15.0,5.0,6.0,10.0,6.0,2.0,2.0,2.0,1.0,9.0,18.0,4.0,3.0] //post
        
        // Sample data
        let values: [Double] = [8, 104, 81, 93, 52, 44, 97, 101, 75, 28,
                                76, 25, 20, 13, 52, 44, 57, 23, 45, 91,
                                99, 14, 84, 48, 40, 71, 106, 41, 45, 61]
        
        var entries: [ChartDataEntry] = Array()
        
        for (i, value) in values.enumerated()
        {
            entries.append(BarChartDataEntry(x: Double(i), y: value))
        }
        
        dataSet = BarChartDataSet(values: entries, label: "Bar chart unit test data")
        
        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.85
        
        // chart = BarChartView(frame: CGRect(x: 0, y: 0, width: 480, height: 350))
        barChartView.backgroundColor = NSUIColor.clear
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.rightAxis.axisMinimum = 0.0
        barChartView.data = data
    }
        
    @IBOutlet weak var barChartView: BarChartView!

}

