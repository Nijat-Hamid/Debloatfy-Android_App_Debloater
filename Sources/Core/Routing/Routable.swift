//
//  RouterProtocol.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/23/25.
//

import SwiftUI

protocol Routable {
    
    associatedtype ViewType: View
    
    var currentPage: Route { get }
    
    func makeView(for route:Route) -> ViewType
    
    func setView(for route:Route) -> ()
}


enum Route {
    case overview
    case debloat
    case restore
    case about
    case transfer
    case debugging
    case logs
    
    var title:String {
        switch self {
        case .overview: "Overview"
        case .debloat: "Debloat"
        case .restore: "Restore"
        case .transfer: "Transfer"
        case .about: "About"
        case .logs: "Logs"
        default:""
        }
    }
    
    var icon:String {
        switch self {
        case .overview: "tent.circle"
        case .debloat: "square.3.layers.3d"
        case .restore: "checkmark.arrow.trianglehead.counterclockwise"
        case .transfer: "arrow.up.arrow.down"
        case .about: "exclamationmark.circle"
        case .logs: "document.viewfinder"
        default: "xmark.shield"
        }
    }
    
    
}
