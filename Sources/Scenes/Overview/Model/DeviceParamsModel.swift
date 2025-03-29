//
//  Untitled.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/29/25.
//

struct DeviceParamsModel {
   var companyName:String
   var deviceModel:String
   var androidVersion:String
   var securityPatch:String
   var deviceID:String
   var deviceBL:String
   var product:String
   var build:String
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
