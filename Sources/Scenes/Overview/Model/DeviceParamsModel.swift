//
//  Untitled.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/29/25.
//

struct DeviceParamsModel {
    var companyName: String = "N/A"
    var deviceModel: String = "N/A"
    var androidVersion: String = "N/A"
    var securityPatch: String = "N/A"
    var deviceID: String = "N/A"
    var deviceBL: String = "N/A"
    var product: String = "N/A"
    var build: String = "N/A"
}

extension DeviceParamsModel:Mockable {
    
    typealias MockType = DeviceParamsModel
    
    static var mock: MockType {
        MockType(companyName: "Samsung",
                 deviceModel: "SM-916B",
                 androidVersion: "v15",
                 securityPatch: "2025-02-01",
                 deviceID: "R5CW22MLZ7H",
                 deviceBL: "S916BXXUCYB4",
                 product: "dm2qxxx",
                 build: "UP1A.231005")
    }
}
