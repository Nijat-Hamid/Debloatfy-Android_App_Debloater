//
//  DBService.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/13/25.
//
import GRDB
import Foundation

final class DBService {
    private let dbQueue: DatabaseQueue
    
    static let shared = DBService()
    
    private init() {
        dbQueue = try! DatabaseQueue(path: FileKit.databaseURL)
        
        try! dbQueue.write { db in
            try db.create(table:"logs",ifNotExists: true) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("date", .datetime).notNull()
                t.column("name", .text).notNull()
                t.column("message", .text).notNull()
                t.column("type", .text).notNull()
                t.column("transferFrom", .text)
                t.column("transferTo",.text)
            }
            
        }
    }
    
    
}
