//
//  RouterProtocol.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/23/25.
//

import SwiftUI

protocol Routable {
    
    associatedtype ViewType: View
    
    var currentPage: Route { get set }
    
    func makeView(for route:Route) -> ViewType
    
    func setView(for route:Route) -> ()
}


enum Route {
    case overview
    case debloat
    case restore
    case about
    case adb
    case transfer
    case debugging
    
    var title:String {
        switch self {
        case .overview: "Overview"
        case .debloat: "Debloat"
        case .restore: "Restore"
        case .transfer: "Transfer"
        case .about: "About"
        default:""
        }
    }
    
    var icon:String {
        switch self {
        case .overview: "bubbles.and.sparkles"
        case .debloat: "square.3.layers.3d"
        case .restore: "wrench.and.screwdriver"
        case .transfer: "arrow.up.arrow.down"
        case .about: "exclamationmark.circle"
        default: "xmark.shield"
        }
    }
    
    
}
