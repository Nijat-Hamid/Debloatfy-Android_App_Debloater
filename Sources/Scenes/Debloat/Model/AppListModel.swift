//
//  AppListModel.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/29/25.
//

import Foundation

enum ListAppType:String {
    case user = "User"
    case system = "System"
    case none = "N/A"

}

struct AppListModel:Identifiable, Equatable, Hashable {
    var id: UUID = UUID()
    var package:String = "N/A"
    var type:ListAppType = .none
    var size:String = "N/A"
}


extension AppListModel:Mockable {
    typealias MockType = AppListModel
    
    static var mock: AppListModel {
        MockType(package: "com.package.facebook", type: .user, size: "82")
    }
    
    static var mockList: [AppListModel] {
        [
            MockType(package: "com.package.facebook", type: .user, size: "82"),
            MockType(package: "com.package.galaxystore", type: .system, size: "145"),
            MockType(package: "com.package.whatsapp", type: .user, size: "45"),
            MockType(package: "com.package.youtube", type: .system, size: "236"),
        ]
    }
}
