//
//  FileManager.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/8/25.
//

import Foundation

struct FileKit {
    private static let appDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let backupDir = appDir.appending(path: "\(Utils.appName)").appending(component: "Backups")
    
    static let backupPath = backupDir.path()
    
    static let backupJson = backupDir.appending(component: "backup_info.json")
    
    static var existsBackupDir:Bool {
        FileManager.default.fileExists(atPath: backupPath)
    }
    
    static var existsBackupJson:Bool {
        FileManager.default.fileExists(atPath: backupJson.path())
    }
    
    static func createBackupDirIfNeeded() throws {
        try FileManager.default.createDirectory(at: backupDir, withIntermediateDirectories: true)
    }
    
    static func existsApkDir (_ packageName:String) ->Bool {
        let packagePath = backupDir.appending(path: packageName).path()
        
        return FileManager.default.fileExists(atPath: packagePath)
    }
    
    static func returnApkDir (_ packageName:String) -> URL {
        return backupDir.appending(path: packageName)
    }
    
    static let defaultTransferDir = appDir.appending(path: "\(Utils.appName)").appending(component: "Transfers")
    
    static let databaseURL = appDir.appending(path: "\(Utils.appName)/Database")
    
    static func createDatabaseDirIfNeeded() throws {
        try FileManager.default.createDirectory(at: databaseURL, withIntermediateDirectories: true)
    }
}
