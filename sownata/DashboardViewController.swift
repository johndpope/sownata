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

    func setChart(_ dataPoints: [String], values: [Double], moreValues: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
//        var dataEntries2: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(values: [values[i],moreValues[i]], xIndex: i)
            dataEntries.append(dataEntry)
//            let dataEntry2 = BarChartDataEntry(value: moreValues[i], xIndex: i)
//            dataEntries2.append(dataEntry2)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: nil)
        chartDataSet.colors = [ UIColor.purple, UIColor.orange ]
        chartDataSet.stackLabels = ["Likes","Posts"]

//        let chartDataSet2 = BarChartDataSet(yVals: dataEntries2, label: "Units Returned")
//        chartDataSet2.colors = [ UIColor.orangeColor() ]

        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        barChartView.data = chartData
        
        barChartView.descriptionText = ""
        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.current.orientation.isLandscape {
            print("Landscape (Dashboard)")
        }
        else if UIDevice.current.orientation.isPortrait {
            print("Portrait (Dashboard)")
            navigationController?.popViewController(animated: true)
            self.navigationController?.isNavigationBarHidden = false;
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    
    override func viewDidLoad() {
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationController?.isNavigationBarHidden = true;
        
        barChartView.noDataTextDescription = "???"
        
        months = ["Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar"]
        let unitsSold = [4.0,1.0,2.0,1.0,3.0,3.0,1.0,1.0,2.0,1.0,6.0,3.0,4.0] //like
        let unitsReturned = [15.0,5.0,6.0,10.0,6.0,2.0,2.0,2.0,1.0,9.0,18.0,4.0,3.0] //post
        
        setChart(months, values: unitsSold, moreValues: unitsReturned)
    }
        
    @IBOutlet weak var barChartView: BarChartView!

}

