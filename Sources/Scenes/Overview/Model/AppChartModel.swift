//
//  AppChartModel.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/29/25.
//

struct AppChartModel {
    var category: String = "N/A"
    var count: Int = 0
}

extension AppChartModel:Mockable {
    
    typealias MockType = AppChartModel
    
    static var mock: AppChartModel {
        MockType(category: "System", count: 300)
    }
    
    static var mockList: [AppChartModel] {
        [
            MockType(category: "System", count: 300),
            MockType(category: "User", count: 150)
        ]
    }
}
