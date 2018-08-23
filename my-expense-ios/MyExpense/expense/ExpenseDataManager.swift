//
//  ExpenseDataManager.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/15/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import Foundation
import Charts

class ExpenseDataManager {
    
    static func toDetailList(expenses: [Expense]?) -> [ExpenseDetail] {
        guard let exps = expenses else {
            return []
        }
        
        let dict = Dictionary(grouping: exps) { $0.toDate()! }
        
        return dict.map { ExpenseDetail(date: $0, amount: $1.map({ $0.amount }).reduce(0, +)) }
    }
    
    static func pieChartDataByCategory(expenses: [Expense]?) -> PieChartData? {
        
        guard let exps = expenses, exps.count > 0 else {
            return nil
        }
        
        let dict = Dictionary(grouping: exps, by: { $0.category!.name! })
        
        var dataEntries: [ChartDataEntry] = []
        var colors: [UIColor] = []

        for (k, v) in dict {
            let total = v.map({ $0.amount }).reduce(0, +)
            let chartData = PieChartDataEntry(value: total, label: k)
            dataEntries.append(chartData)
            colors.append(CATEGORYCOLORS[v.first!.category!.color.toInt()]!)
        }
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = colors
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        formatter.multiplier = 1
        
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        
        return PieChartData(dataSet: chartDataSet)
    }
    
    static func barChartDataByCategory(expenses: [Expense]?) -> BarChartData? {
        
        guard let exps = expenses, exps.count > 0 else {
            return nil
        }
        
        let dict = Dictionary(grouping: exps, by: { $0.category!.name! })
        
        var dataEntries: [ChartDataEntry] = []
        var colors: [UIColor] = []
        
        var i = 1.0
        for (_, v) in dict {
            let total = v.map({ $0.amount }).reduce(0, +)
            let chartData = BarChartDataEntry(x: i, y: total)
            dataEntries.append(chartData)
            colors.append(CATEGORYCOLORS[v.first!.category!.color.toInt()]!)
            
            i += 1.0
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Categories")
        chartDataSet.colors = colors
        
        return BarChartData(dataSet: chartDataSet)
    }
    
}
