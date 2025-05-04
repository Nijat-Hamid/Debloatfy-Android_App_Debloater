//
//  ADB.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/28/25.
//

import Foundation

struct ADB {
    
    static func run(arguments: [Commands],wait:Bool = true) async -> Result {
        guard let path = Bundle.main.path(forResource: "adb", ofType: nil) else {
            return .failure(error: .executableNotFound, code: -1, rawOutput: "")
        }
        
        assert(!Thread.isMainThread, "This function must run not the main thread!")
        return await withCheckedContinuation { continuation in
            let task = Process()
            task.launchPath = path
            task.arguments = arguments.flatMap { $0.rawComponents }
            let pipe = Pipe()
            task.standardOutput = pipe
            task.standardError = pipe
    
            do {
                try task.run()
                
                if wait {
                    task.waitUntilExit()
                }
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let statusCode = task.terminationStatus
                
                if let output = String(data: data, encoding: .utf8) ??
                    String(data: data, encoding: .unicode) ??
                    String(data: data, encoding: .ascii) ??
                    String(data: data, encoding: .windowsCP1254) {
                    
                    if statusCode == 0 {
                        continuation.resume(returning: .success(output: output, code: statusCode))
                    } else if arguments.contains(where: {
                        if case .getApkSize = $0 { return true }
                        return false
                    }) {
                        continuation.resume(returning: .success(output: output, code: 0))
                    } else {
                        let error = ADBError.determineError(from: output, code: statusCode)
                        continuation.resume(returning: .failure(error: error, code: statusCode, rawOutput: output))
                    }
                } else {
                    continuation.resume(returning: .failure(error: .decodingError, code: statusCode, rawOutput: ""))
                }
            } catch {
                print("❌ Process Error: \(error.localizedDescription) - \(task.terminationStatus)")
                continuation.resume(
                    returning: .failure(error: .processError(description: error.localizedDescription),
                                        code: task.terminationStatus,
                                        rawOutput: ""
                                       ))
            }
        }
    }
}

extension ADB {
    enum Commands {
        case kill, start, devices, reboot, getBootloader, getCompany, getModel, getProduct, getSecurityPatch, getAndroidVersion, getBuildID, getDeviceID, getListSystemApps, getListUserApps, getApksFullPath(String), getApkSize(String), uninstallApk(String), backupApk(String, String), restoreApk(String), getInternalStorage,getContentSize(String),custom(String), detectType(String), deleteFile(String), deleteFolder(String), copyToPhone(String), copyToPC(String,String), reconnect, auth
        
        var raw:String {
            switch self {
            case .auth:return "devices && adb get-serialno"
            case .kill: return "kill-server"
            case .start: return "start-server"
            case .devices: return "devices"
            case .reconnect: return "reconnect"
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
            case .uninstallApk(let package): return "shell pm uninstall --user 0 \(package)"
            case .backupApk(let from, let to): return "pull \(from) \(to)"
            case .restoreApk(let splitApks): return "install-multiple \(splitApks)"
            case .getInternalStorage: return "shell LC_ALL=C.UTF-8 ls /sdcard/"
            case .getContentSize(let name): return "shell du -sm /sdcard/\(name)"
            case .custom(let command):return "\(command)"
            case .detectType(let name):return "shell test -d /sdcard/\(name) && echo 'directory' || echo 'file'"
            case .deleteFile(let name):return "shell rm /sdcard/\(name)"
            case .deleteFolder(let name):return "shell rm -r /sdcard/\(name)"
            case .copyToPhone(let from): return "push '\(from)' /sdcard/"
            case .copyToPC(let name,let to): return "pull -a /sdcard/\(name) \(to)"
            }
        }
        
        var rawComponents: [String] {
            switch self {
            case .copyToPhone(let from):
                return ["push", from, "/sdcard/"]
            case .getContentSize(let content):
                return ["shell", "du -sm", "/sdcard/\(content)"]
            default:
                return raw.split(separator: " ").map(String.init)
            }
        }
    }
    
    enum Result {
        case success(output:String, code:Int32)
        case failure(error: ADBError, code: Int32, rawOutput: String)
    }
    
    enum ADBError:Error {
        case executableNotFound, permissionDenied, deviceNotFound, fileNotFound, noDevicesConnected, installFailed, pushFailed, pullFailed, commandFailed, decodingError, processError(description: String), unknown(description: String)
        
        var message: String {
            switch self {
            case .executableNotFound:
                return "ADB executable not found"
            case .permissionDenied:
                return "Permission denied. Root privileges may be required"
            case .deviceNotFound:
                return "Device not found or disconnected"
            case .fileNotFound:
                return "File or directory not found"
            case .noDevicesConnected:
                return "No devices connected"
            case .installFailed:
                return "Application installation failed"
            case .pushFailed:
                return "Failed to push file to device"
            case .pullFailed:
                return "Failed to pull file from device"
            case .commandFailed:
                return "Failed to execute ADB command"
            case .decodingError:
                return "Error decoding output"
            case .processError(let description):
                return "Process error: \(description)"
            case .unknown(let description):
                return "Unknown error: \(description)"
            }
        }
        
        static func determineError(from output: String, code: Int32) -> ADBError {
            let lowercaseOutput = output.lowercased()
            
            if lowercaseOutput.contains("permission denied") || lowercaseOutput.contains("access denied") {
                return .permissionDenied
            } else if lowercaseOutput.contains("device not found") || lowercaseOutput.contains("device '(null)' not found") {
                return .deviceNotFound
            } else if lowercaseOutput.contains("no such file") || lowercaseOutput.contains("no such file or directory") {
                return .fileNotFound
            } else if lowercaseOutput.contains("no devices/emulators found") || lowercaseOutput.contains("no devices found") {
                return .noDevicesConnected
            } else if lowercaseOutput.contains("failure") && lowercaseOutput.contains("install") {
                return .installFailed
            } else if lowercaseOutput.contains("failed to copy") && lowercaseOutput.contains("push") {
                return .pushFailed
            } else if lowercaseOutput.contains("failed to copy") && lowercaseOutput.contains("pull") {
                return .pullFailed
            } else {
                return .unknown(description: output)
            }
        }
    }
}
