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
                try? await Task.sleep(for: .seconds(0.5))
                isLoading = false
            }
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        await executeADBCommand(.getCompany,
                                property: \.companyName,
                                transform: { $0.capitalized },
                                errorContext: "Failed to get company")
        
        await executeADBCommand(.getModel,
                                property: \.deviceModel,
                                errorContext: "Failed to get device model")
        
        await executeADBCommand(.getAndroidVersion,
                                property: \.androidVersion,
                                transform: { "v\($0)" },
                                errorContext: "Failed to get Android version")
        
        await executeADBCommand(.getSecurityPatch,
                                property: \.securityPatch,
                                errorContext: "Failed to get security patch")
        
        await executeADBCommand(.getDeviceID,
                                property: \.deviceID,
                                errorContext: "Failed to get device ID")
        
        await executeADBCommand(.getBootloader,
                                property: \.deviceBL,
                                errorContext: "Failed to get bootloader status")
        
        await executeADBCommand(.getProduct,
                                property: \.product,
                                errorContext: "Failed to get product info")
        
        await executeADBCommand(.getBuildID,
                                property: \.build,
                                errorContext: "Failed to get build ID")
        
        await getAppList(command: .getListSystemApps, category: "System")
        await getAppList(command: .getListUserApps, category: "User")
        
    }
    
    private func executeADBCommand(
        _ command: ADB.Commands,
        property keyPath: WritableKeyPath<DeviceParamsModel, String>,
        transform: ((String) -> String)? = nil,
        errorContext: String
    ) async {
        switch await ADB.run(arguments: [command]) {
        case .success(let output, _):
            let trimmed = output.trimmingCharacters(in: .whitespacesAndNewlines)
            let value = transform?(trimmed) ?? trimmed
            deviceParams[keyPath: keyPath] = value
        case .failure(let error, _, _):
            Log.of(.viewModel(OverviewVM.self)).warning("\(error.message)")
        }
    }
    
    private func getAppList(command: ADB.Commands, category: String) async {
        switch await ADB.run(arguments: [command]) {
        case .success(let output, _):
            let filteredOutput = output
                .split(separator: "\n")
                .filter { $0.starts(with: "package:") }
            
            appChartData.append(.init(category: category, count: filteredOutput.count))
        case .failure(let error, _, _):
            appChartData.append(.init(category: category, count: 0))
            Log.of(.viewModel(OverviewVM.self)).error("\(error.message)")
        }
    }
}
