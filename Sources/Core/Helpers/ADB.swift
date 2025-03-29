//
//  ADB.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/28/25.
//

import Foundation

struct ADB {
    
    static func run(arguments: [Commands],wait:Bool = false) async -> String? {
        guard let path = Bundle.main.path(forResource: "adb", ofType: nil) else { return nil }
        
        return await withCheckedContinuation { continuation in
            let task = Process()
            task.launchPath = path
            task.arguments = arguments.flatMap { $0.rawValue.split(separator: " ").map(String.init)}
            let pipe = Pipe()
            task.standardOutput = pipe
            task.standardError = pipe
            
            do {
                try task.run()
                
                if wait {
                    task.waitUntilExit()
                }
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8)
                continuation.resume(returning: output)
            } catch {
                print("❌ Process Error: \(error.localizedDescription)")
                continuation.resume(returning: nil)
            }
        }
    }
}

extension ADB {
    enum Commands:String {
        case kill = "kill-server"
        case start = "start-server"
        case devices = "devices"
        case reboot = "reboot"
        case getBootloader = "shell getprop ro.bootloader"
        case getCompany = "shell getprop ro.product.manufacturer"
        case getModel = "shell getprop ro.product.model"
        case getProduct = "shell getprop ro.product.name"
        case getSecurityPatch = "shell getprop ro.build.version.security_patch"
        case getAndroidVersion = "shell getprop ro.build.version.release"
        case getBuildID = "shell getprop ro.build.id"
        case getDeviceID = "shell getprop ro.serialno"
        case getListSystemApps = "shell pm list packages -s"
        case getListUserApps = "shell pm list packages -3"


    }
}
