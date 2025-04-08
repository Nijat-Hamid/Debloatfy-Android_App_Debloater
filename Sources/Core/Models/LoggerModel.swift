//
//  LoggerModel.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/2/25.
//

import SwiftData
import Foundation

@Model
final class LoggerModel:Identifiable {
    @Attribute(.unique) var id:UUID = UUID()
    var date: Date = Date()
    var name: String
    var type: LogType
    
    var message:String {
        self.type.message(for: name)
    }
    
    init(name: String, type: LogType) {
        self.name = name
        self.type = type
    }
}

extension LoggerModel:Mockable {
    typealias MockType = LoggerModel
    
    static var mock: LoggerModel {
        MockType(name: "com.package.facebook", type: .remove)
    }
    
    static var mockList: [LoggerModel] {
        [
            MockType(name: "com.package.facebook", type: .remove),
            MockType(name: "Data", type: .transfer("/Sdcard", "/Desktop")),
            MockType(name: "com.package.whatsapp", type: .backup),
            MockType(name: "com.package.instagram", type: .restoreRemove),
            MockType(name: "com.package.music", type: .restore)
        ]
    }
    
    enum LogType:Codable {
        case transfer(String,String), remove, backup, restore,backupRemove, restoreRemove
        
        var typeTitle:String {
            switch self {
            case .transfer: "Transfer"
            case .remove: "Remove"
            case .backup: "Backup"
            case .restore: "Restore"
            case .backupRemove: "Backup & Remove"
            case .restoreRemove: "Restore & Remove"
            }
        }
        
        func message(for name: String) -> String {
            switch self {
            case .transfer(let from, let to):
                return "\(name) transferred from \(from) to \(to)."
            case .remove:
                return "\(name) was removed."
            case .backup:
                return "\(name) was backed up."
            case .restore:
                return "\(name) was restored."
            case .backupRemove:
                return "\(name) was backed up and then removed."
            case .restoreRemove:
                return "\(name) was restored and then removed."
            }
        }
    }
    
    
}
