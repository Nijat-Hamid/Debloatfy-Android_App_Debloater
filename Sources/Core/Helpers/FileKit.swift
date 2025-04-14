//
//  FileManager.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/8/25.
//

import Foundation

struct FileKit {
    static let manager = FileManager.default
    
    private static let appDir = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let backupDir = appDir.appending(path: "\(Utils.appName)").appending(component: "Backups")
    
    static let backupPath = backupDir.path()
    
    static let backupJson = backupDir.appending(component: "backup_info.json")
    
    static var existsBackupDir:Bool {
        manager.fileExists(atPath: backupPath)
    }
    
    static var existsBackupJson:Bool {
        manager.fileExists(atPath: backupJson.path())
    }
    
    static func createBackupDirIfNeeded() throws {
        try manager.createDirectory(at: backupDir, withIntermediateDirectories: true)
    }
    
    static func existsApkDir (_ packageName:String) ->Bool {
        let packagePath = backupDir.appending(path: packageName).path()
        
        return manager.fileExists(atPath: packagePath)
    }
    
    static func returnApkDir (_ packageName:String) -> URL {
        return backupDir.appending(path: packageName)
    }
    
    static let defaultTransferDir = appDir.appending(path: "\(Utils.appName)").appending(component: "Transfers")
    
    static let databaseURL = appDir.appending(path: "\(Utils.appName)/Database")
    
    static func createDatabaseDirIfNeeded() throws {
        try manager.createDirectory(at: databaseURL, withIntermediateDirectories: true)
    }
}
