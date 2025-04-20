//
//  OverviewVM.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/28/25.
//

import SwiftUI

@MainActor @Observable
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
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        async let getCompany = Processors.executeADBCommand(.getCompany)
        async let getDeviceModel = Processors.executeADBCommand(.getModel)
        async let getAndroidVersion = Processors.executeADBCommand(.getAndroidVersion)
        async let getSecurityPatch = Processors.executeADBCommand(.getSecurityPatch)
        async let getDeviceID = Processors.executeADBCommand(.getDeviceID)
        async let getBootloader = Processors.executeADBCommand(.getBootloader)
        async let getProduct = Processors.executeADBCommand(.getProduct)
        async let getBuild = Processors.executeADBCommand(.getBuildID)
        
        async let getSysAppCount = Processors.getAppList(.getListSystemApps)
        async let getUserAppCount = Processors.getAppList(.getListUserApps)
        
        let (company, model, androidVer, patch, deviceID, bootloader, product, build, sysApps, userApps) = await (getCompany, getDeviceModel, getAndroidVersion, getSecurityPatch, getDeviceID, getBootloader, getProduct, getBuild, getSysAppCount, getUserAppCount)
        
        deviceParams.companyName = company.capitalized
        deviceParams.deviceModel = model
        deviceParams.androidVersion = "v\(androidVer)"
        deviceParams.securityPatch = patch
        deviceParams.deviceID = deviceID
        deviceParams.deviceBL = bootloader
        deviceParams.product = product
        deviceParams.build = build
        appChartData.append(.init(category: "System", count: sysApps))
        appChartData.append(.init(category: "User", count: userApps))
        
        
        try? await Task.sleep(for: .seconds(0.1))
        
        isLoading = false
    }
}
