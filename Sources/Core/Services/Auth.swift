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
    
    func killServer() async {
        isLoading = true
        
        defer { isLoading = false }
        
        let result = await ADB.run(arguments: [.devices])
        
        switch result {
        case .success(let output, _):
            Log.of(.services(Auth.self)).info("\(output)")
        case .failure(let error, _, _):
            Log.of(.services(Auth.self)).error("\(error.message)")
        }
    }
    
    func startServer() async {
        isLoading = true
        
        defer { isLoading = false }
        
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
            }
            
            Log.of(.services(Auth.self)).info("Access granted!")
            
        case .failure(let error, _, _):
            isConnected = false
            isDebugEnabled = false
            Log.of(.services(Auth.self)).error("\(error.message)")
        }
    }
}
