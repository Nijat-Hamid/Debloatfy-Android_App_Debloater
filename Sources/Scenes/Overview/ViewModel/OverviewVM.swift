//
//  OverviewVM.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/28/25.
//

import SwiftUI

@Observable
final class OverviewVM {
    
    private let auth: Auth
    
    init(auth:Auth = Auth.shared) {
        self.auth = auth
    }
    
    private(set) var isLoading:Bool = false
    private(set) var deviceParams:DeviceParamsModel = .init()
    private(set) var appChartData: [AppChartModel] = []
   
    func getDeviceData() async {
        
        isLoading = true
        defer {
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000 )
                isLoading = false
            }
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else {
            print("Access not granted, returning early")
            return
        }
        

        if let getCompany = await ADB.run(arguments: [.getCompany]) {
            deviceParams.companyName = getCompany.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
        }
        
        if let getDeviceModel = await ADB.run(arguments: [.getModel]) {
            deviceParams.deviceModel = getDeviceModel.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    
        if let getAndroidVersion = await ADB.run(arguments: [.getAndroidVersion]) {
            deviceParams.androidVersion = "v\(getAndroidVersion.trimmingCharacters(in: .whitespacesAndNewlines))"
        }
        
        if let getSecurityPatch = await ADB.run(arguments: [.getSecurityPatch]) {
            deviceParams.securityPatch = getSecurityPatch.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let getDeviceID = await ADB.run(arguments: [.getDeviceID]) {
            deviceParams.deviceID = getDeviceID.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let getDeviceBL = await ADB.run(arguments: [.getBootloader]) {
            deviceParams.deviceBL = getDeviceBL.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let getProduct = await ADB.run(arguments: [.getProduct]) {
            deviceParams.product = getProduct.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let getBuild = await ADB.run(arguments: [.getBuildID]) {
            deviceParams.build = getBuild.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let getSystemApps = await ADB.run(arguments: [.getListSystemApps]) {
            let filteredOutput = getSystemApps
                .split(separator: "\n")
                .filter { $0.starts(with: "package:") }
            
            appChartData.append(.init(category: "System", count: filteredOutput.count))
        }
        
        if let getUserApps = await ADB.run(arguments: [.getListUserApps]) {
            let filteredOutput = getUserApps
                .split(separator: "\n")
                .filter { $0.starts(with: "package:") }
            
            appChartData.append(.init(category: "User", count: filteredOutput.count))
        }
        
     }
    
    
}
