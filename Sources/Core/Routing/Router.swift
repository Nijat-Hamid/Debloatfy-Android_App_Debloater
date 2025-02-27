//
//  Router.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/23/25.
//

import SwiftUI

@Observable
final class Router:Routable {
    
    var currentPage: Route = .overview
    
    @ViewBuilder
    func makeView(for route: Route) -> some View {
        switch route {
        case .overview: OverviewView()
        case .debloat: DebloatView()
        case .restore: RestoreView()
        case .transfer: TransferView()
        case .about: AboutView()
        case .adb: ADBView()
        case .debugging: DebuggingView()
        }
    }
    
    func setView(for route: Route) {
        currentPage = route
    }
   
}
