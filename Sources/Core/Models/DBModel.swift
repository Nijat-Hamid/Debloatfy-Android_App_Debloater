//
//  DBModel.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/2/25.
//

import Foundation
import GRDB

struct DBModel:Codable,Identifiable,Equatable,FetchableRecord,PersistableRecord {
    var id: Int64?
    var date: Date
    var name: String
    var message: String
    var type: String
 
    init(id: Int64? = nil, date: Date = Date(), name: String, type: LogType, from: String = "-", to: String = "-") {
        self.id = id
        self.date = date
        self.name = name
        self.message = type.generateMessage(type: type, from: from, to: to)
        self.type = type.rawValue
    }
    
    static var databaseTableName: String {
        return "database"
    }
}

extension DBModel:Mockable {
    typealias MockType = DBModel
    
    static var mock: DBModel {
        DBModel(name: "Mp3", type: .transfer, from: "Desktop", to: "Internal Storage")
    }
   
    static var mockList: [DBModel] {
        [
            DBModel(name: "com.facebook.android", type: .remove),
            DBModel(name: "com.whatsapp", type: .backup),
            DBModel(name: "com.samsung", type: .backupRemove),
            DBModel(name: "com.instagram.dro", type: .restoreRemove)
        ]
    }
    
    enum LogType:String {
        case transfer, remove, backup, restore,backupRemove, restoreRemove, fileRemove
        
        var typeTitle:String {
            switch self {
            case .transfer: "Transfer"
            case .remove,.fileRemove: "Remove"
            case .backup: "Backup"
            case .restore: "Restore"
            case .backupRemove: "Backup & Remove"
            case .restoreRemove: "Restore & Remove"
            }
        }
        
         func generateMessage(type: LogType, from: String = "-", to: String = "-") -> String {
            switch type {
            case .transfer:
                return "Copied from \(from) to \(to)."
            case .remove:
                return "App was removed from \(from)"
            case .backup:
                return "App was backed up to \(to)"
            case .restore:
                return "App was restored to \(to)"
            case .backupRemove:
                return "App was backed up and then removed."
            case .restoreRemove:
                return "App was restored and then removed."
            case .fileRemove:
                return "Content was removed from Phone"
            }
        }
        
        static func safeTitle(from rawValue: String) -> String {
            Self(rawValue: rawValue)?.typeTitle ?? "N/A"
        }
    }
    
    
}
