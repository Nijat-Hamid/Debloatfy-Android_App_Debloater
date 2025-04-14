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
        do{
            if !FileKit.manager.fileExists(atPath: FileKit.databaseURL.path()) {
                try FileKit.createDatabaseDirIfNeeded()
            }
            let databaseUrl = FileKit.databaseURL.appending(component: "db.sqlite")
            
            dbQueue = try DatabaseQueue(path: databaseUrl.path())
            
            try dbQueue.write { db in
                try db.create(table:"database",ifNotExists: true) { t in
                    t.autoIncrementedPrimaryKey("id")
                    t.column("date", .datetime).notNull()
                    t.column("name", .text).notNull()
                    t.column("message", .text).notNull()
                    t.column("type", .text).notNull()
                }
            }
        }catch{
            Log.of(.services(DBService.self)).critical("Unresolved error:\(error)")
            fatalError("Unresolved error \(error)")
        }
    }
    
    func get() async throws -> [DBModel] {
        try await dbQueue.read { db in
            try DBModel.fetchAll(db)
        }
    }
    
    func save(_ dbModel: DBModel) async throws {
        try await dbQueue.write { db in
            try dbModel.save(db)
        }
    }
    
    func deleteAll() async throws {
        _ = try await dbQueue.write { db in
            try DBModel.deleteAll(db)
        }
    }
    
}
