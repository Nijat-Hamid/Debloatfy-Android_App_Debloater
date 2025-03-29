//
//  Auth.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/25/25.
//

import SwiftUI

@Observable
final class Auth {

    static let shared = Auth()
    
    private init(){}
    
    private(set) var isDebugEnabled:Bool = false
    private(set) var isConnected:Bool = false
    private(set) var isLoading:Bool = false
    
    var isAccessed:Bool {
        return isDebugEnabled && isConnected
    }
    
    func startServer() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let output = await ADB.run(arguments: [.devices]) else {
            isConnected = false
            isDebugEnabled = false
            return
        }

        let splittedOutput = output.split(separator: "\n")
        
        let connectedDevices = splittedOutput.filter {
            ($0.contains("device") || $0.contains("unauthorized")) &&
            !$0.contains("List of devices attached")
        }
        
        isConnected = !connectedDevices.isEmpty
        isDebugEnabled = isConnected && !connectedDevices.contains { $0.contains("unauthorized") }
        
//        isConnected = splittedOutput.count > 1 && splittedOutput
//            .filter { ($0.contains("device") || $0.contains("unauthorized")) && !$0.contains("List of devices attached") }
//            .count > 0
//        
//        isDebugEnabled = splittedOutput.count > 1 && !splittedOutput
//            .contains { $0.contains("unauthorized") }
//        
//        isLoading = false
        
    }
    
}
