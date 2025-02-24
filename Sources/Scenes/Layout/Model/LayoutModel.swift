//
//  SidebarModel.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/14/25.
//

import Foundation

struct Section<T: Identifiable & Equatable>: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let items: [T]
}


struct NavigationItem: Identifiable,Equatable {
    let id = UUID()
    let type: Route
    var title: String {
        type.title
    }
    
    var icon: String {
        type.icon
    }
}


struct SocialItem:Identifiable,Equatable {
    let id = UUID()
    let name: String
    let url: String
    let icon: String
}

