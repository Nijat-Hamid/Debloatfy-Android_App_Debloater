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
    var isDisabled:Bool = false
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


extension NavigationItem:Mockable {
    typealias MockType = NavigationItem
    
    static var mock: NavigationItem {
        MockType(type: .transfer)
    }
    
    static func mockFunc() -> NavigationItem {
        MockType(type: .transfer, isDisabled: true)
    }
    
    static var mockList: [NavigationItem] {
        [
            MockType(type: .overview),
            MockType(type: .debloat),
            MockType(type: .transfer, isDisabled: true),
            MockType(type: .about)
        ]
    }
    
}

extension SocialItem:Mockable {
    typealias MockType = SocialItem
    
    static var mock: SocialItem {
        MockType(name: "Linkedin", url: "https", icon: "linkedin")
    }
    
    static var mockList: [SocialItem] {
        [
            MockType(name: "Github", url: "https", icon: "github"),
            MockType(name: "Linkedin", url: "https", icon: "linkedin"),
        ]
    }
}
