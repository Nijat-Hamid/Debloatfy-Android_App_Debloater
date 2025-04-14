//
//  LogDBModel.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/2/25.
//
import RealmSwift
import Foundation

final class LogDBModel:Object {
    @Persisted(primaryKey: true) var id:ObjectId
    @Persisted var date: Date = Date()
    @Persisted var name: String = "N/A"
    @Persisted var type: LogType = .transfer
    @Persisted var transferFrom: String?
    @Persisted var transferTo: String?
    @Persisted var message:String
    
    convenience init(name: String, type: LogType, transferFrom: String? = nil, transferTo: String? = nil) {
        self.init()
        self.name = name
        self.type = type
        self.transferFrom = transferFrom
        self.transferTo = transferTo
        self.message = type.generateMessage(name: name, type: type, from: transferFrom, to: transferTo)
    }
}

extension LogDBModel:Mockable {
    typealias MockType = LogDBModel
    
    static var mock: LogDBModel {
        MockType(name: "Mp3", type: .transfer,transferFrom: "Desktop",transferTo: "Internal Storage")
    }
    
    static var mockList: [LogDBModel] {
        [
            MockType(name: "com.facebook.android", type: .remove),
            MockType(name: "com.whatsapp", type: .backup),
            MockType(name: "com.samsung", type: .backupRemove),
            MockType(name: "com.instagram.dro", type: .restoreRemove),
        ]
    }
    
    enum LogType:String,PersistableEnum {
        case transfer, remove, backup, restore,backupRemove, restoreRemove
        
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
        
         func generateMessage(name: String, type: LogType, from: String?, to: String?) -> String {
            switch type {
            case .transfer:
                return "\(name) transferred from \(from ?? "Unknown") to \(to ?? "Unknown")."
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
