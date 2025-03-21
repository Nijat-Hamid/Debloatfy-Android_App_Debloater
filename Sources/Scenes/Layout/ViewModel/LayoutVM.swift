//
//  LayoutVM.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/14/25.
//
import SwiftUI

@Observable
final class LayoutVM {
    
    private let navigationSection:[Section<NavigationItem>] = [
        Section(title: "DASHBOARD", items: [
            NavigationItem(type: .overview),
            NavigationItem(type: .debloat),
            NavigationItem(type: .restore),
            NavigationItem(type: .transfer,isDisabled: true),
            NavigationItem(type: .logs),
            NavigationItem(type: .about),
        ]),
    ]
    
    var navData:[Section<NavigationItem>] {
        return navigationSection
    }
    
    
    private let socialMedia:[Section<SocialItem>] = [
        Section(title: "SOCIAL MEDIA", items: [
            SocialItem(name: "Github", url: "https://github.com/Nijat-Hamid", icon: "github"),
            SocialItem(name: "Linkedin", url: "https://www.linkedin.com/in/nijat-hamid", icon: "linkedin")
        ])
    ]
    
    
    var socialData:[Section<SocialItem>] {
        return socialMedia
    }
}
