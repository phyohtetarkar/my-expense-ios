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
        
        let dict = Dictionary(grouping: exps) { exp -> (Date) in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            return formatter.date(from: "\(exp.year)/\(exp.month)/\(exp.day)")!
        }
        
        return dict.map { ExpenseDetail(date: $0, amount: $1.map({ $0.amount }).reduce(0, +)) }
    }
    
    static func pieChartDataByCategory(expenses: [Expense]?) -> PieChartData? {
        
        guard let exps = expenses else {
            return nil
        }
        
        let dict = Dictionary(grouping: exps, by: { $0.category!.name! })
        
        var dataEntries: [ChartDataEntry] = []
        var colors: [UIColor] = []

        for (k, v) in dict {
            let total = v.map({ $0.amount }).reduce(0, +)
            let chartData = PieChartDataEntry(value: total, label: k)
            dataEntries.append(chartData)
            colors.append(CATEGORYCOLORS[Int(v.first!.category!.color)]!)
        }
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = colors
        
        return PieChartData(dataSet: chartDataSet)
    }
    
    static func barChartDataByCategory(expenses: [Expense]?) -> BarChartData? {
        
        guard let exps = expenses else {
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
            colors.append(CATEGORYCOLORS[Int(v.first!.category!.color)]!)
            
            i += 1.0
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = colors
        
        return BarChartData(dataSet: chartDataSet)
    }
    
}
