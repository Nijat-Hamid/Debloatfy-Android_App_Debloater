//
//  Auth.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/25/25.
//

import SwiftUI

@MainActor @Observable
final class Auth {

    static let shared = Auth()
    
    private init(){}
    
    private(set) var isDebugEnabled:Bool = false
    private(set) var isConnected:Bool = false
    private(set) var isLoading:Bool = false
    private(set) var deviceID:String? = nil
    
    var isAccessed:Bool {
        return isDebugEnabled && isConnected
    }
    
    func killServer() async {
        isLoading = true
        
        let result = await ADB.run(arguments: [.kill])
        
        switch result {
        case .success(let output, _):
            Log.of(.services(Auth.self)).info("\(output)")
        case .failure(let error, _, _):
            Log.of(.services(Auth.self)).error("\(error.message)")
        }
        
        isLoading = false
    }
    
    func startServer() async {
        isLoading = true
    
        let result = await ADB.run(arguments: [.devices])
        
        switch result {
        case .success(let output, _):
    
            let splittedOutput = output.split(separator: "\n")
            
            let connectedDevices = splittedOutput.filter {
                ($0.contains("device") || $0.contains("unauthorized")) &&
                !$0.contains("List of devices attached")
            }
            
            isConnected = !connectedDevices.isEmpty
            isDebugEnabled = isConnected && !connectedDevices.contains { $0.contains("unauthorized") }
            
            if !isConnected || !isDebugEnabled {
                return Log.of(.services(Auth.self)).warning("Access Denied!")
            } else if isConnected && isDebugEnabled {
                if let deviceString = connectedDevices.first {
                    let components = deviceString.split(separator: "\t")
                    if components.count > 0 {
                        let deviceId = String(components[0])
                        deviceID = deviceId
                    }
                } else {
                    deviceID = nil
                }
            }
            
            Log.of(.services(Auth.self)).info("Access granted!")
            
            
        case .failure(let error, _, _):
            isConnected = false
            isDebugEnabled = false
            deviceID = nil
            Log.of(.services(Auth.self)).error("\(error.message)")
        }
        
        isLoading = false
    }
}
