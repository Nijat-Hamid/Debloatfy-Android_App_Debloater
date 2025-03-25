//
//  UnavailableMod.swift
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
        case .error: return "Something went wrong"
        case .empty: return "No data available"
        case .search: return "No Results"
        case .connection: return "USB connection error"
        }
    }
    
    var description:String {
        switch self {
        case .error: return "Please try again later"
        case .empty: return "No items to display"
        case .search: return "Try a new search"
        case .connection: return "Check USB Connection"
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

struct UnavailableMod:ViewModifier {
    
    private let type:UnavailableType
    
    init(type: UnavailableType) {
        self.type = type
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ContentUnavailableView {
                    Image(systemName: type.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32)
                } description: {
                    VStack(spacing:4) {
                        Text("\(type.title)")
                            .font(.appTitle)
                        Text("\(type.description)")
                            .font(.appHeadline)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(VisualEffect(.background))
                .clipShape(.rect(cornerRadius: 8))
                    
            }
    }
}
