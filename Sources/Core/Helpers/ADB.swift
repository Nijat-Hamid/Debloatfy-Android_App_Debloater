//
//  ADB.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/28/25.
//

import Foundation

struct ADB {
    
    static func run(arguments: [Commands],wait:Bool = true) async -> String? {
        guard let path = Bundle.main.path(forResource: "adb", ofType: nil) else { return nil }
        
        return await withCheckedContinuation { continuation in
            let task = Process()
            task.launchPath = path
            task.arguments = arguments.flatMap { $0.raw.split(separator: " ").map(String.init)}
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
    enum Commands {
        case kill, start, devices, reboot, getBootloader, getCompany, getModel, getProduct, getSecurityPatch, getAndroidVersion, getBuildID, getDeviceID, getListSystemApps, getListUserApps, getApksFullPath(String), getApkSize(String), uninstallApk(String), backupApk(String, String)
        
        var raw:String {
            switch self {
            case .kill: return "kill-server"
            case .start: return "start-server"
            case .devices: return "devices"
            case .reboot: return "reboot"
            case .getBootloader: return "shell getprop ro.bootloader"
            case .getCompany: return "shell getprop ro.product.manufacturer"
            case .getModel: return "shell getprop ro.product.model"
            case .getProduct: return "shell getprop ro.product.name"
            case .getSecurityPatch: return "shell getprop ro.build.version.security_patch"
            case .getAndroidVersion: return "shell getprop ro.build.version.release"
            case .getBuildID: return "shell getprop ro.build.id"
            case .getDeviceID: return "shell getprop ro.serialno"
            case .getListSystemApps: return "shell pm list packages -s"
            case .getListUserApps: return "shell pm list packages -3"
            case .getApksFullPath(let package): return "shell pm path \(package)"
            case .getApkSize(let path): return "shell du -sm \(path)"
            case .uninstallApk(let package): return "shell pm uninstall \(package)"
            case .backupApk(let from, let to): return "pull \(from) \(to)"
            }
        }

    }
}
