//
//  ContentUnavailableMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/24/25.
//

import SwiftUI

enum UnavailableType {
    case error
    case empty
    case search
    case connection
    
    var title:String {
        switch self {
        case .error: return "Oops! Something went wrong"
        case .empty: return "No data available"
        case .search: return "No Results"
        case .connection: return "USB connection error"
        }
    }
    
    var description:String {
        switch self {
        case .error: return "Please try again later"
        case .empty: return "No items to display"
        case .search: return "Check the spelling or try a new search"
        case .connection: return "Check your USB Connection"
        }
    }
    
    var image:String {
        switch self {
        case .error: return "exclamationmark.triangle"
        case .empty: return "viewfinder"
        case .search: return "magnifyingglass"
        case .connection: return "cable.connector.slash"
        }
    }
}

struct ContentUnavailableMod:ViewModifier {
    private let type:UnavailableType
    
    init(type: UnavailableType) {
        self.type = type
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ContentUnavailableView(type.title, systemImage: type.image, description: Text("\(type.description)"))
            }
    }
    
}
