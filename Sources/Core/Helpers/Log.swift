//
//  Log.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/12/25.
//

import OSLog

struct Log {
    private static let subsystem = Utils.bundleID
    
    static func of (_ category: Category) -> Logger {
        Logger(subsystem: subsystem, category: category.message)
    }
}

extension Log {
    enum Category {
        case viewCycle(Any.Type)
        case viewModel(Any.Type)
        case database(Any.Type)
        case helpers(Any.Type)
        case routing(Any.Type)
        case services(Any.Type)
        
        var message:String {
            switch self {
            case .viewCycle(let any): return "View:\(String(describing: any).replacingOccurrences(of: ".Type", with: ""))"
            case .viewModel(let any): return "ViewModel:\(String(describing: any).replacingOccurrences(of: ".Type", with: ""))"
            case .database(let any): return "Database:\(String(describing: any).replacingOccurrences(of: ".Type", with: ""))"
            case .helpers(let any): return "Helpers:\(String(describing: any).replacingOccurrences(of: ".Type", with: ""))"
            case .routing(let any): return "Routing:\(String(describing: any).replacingOccurrences(of: ".Type", with: ""))"
            case .services(let any): return "Services:\(String(describing: any).replacingOccurrences(of: ".Type", with: ""))"
            }
        }
    }
}
