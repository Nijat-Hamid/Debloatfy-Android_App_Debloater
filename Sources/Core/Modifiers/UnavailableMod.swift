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
    case none
    
    var title:String {
        switch self {
        case .error: "Something went wrong"
        case .empty: "No data available"
        case .search: "No Results"
        case .connection: "USB connection error"
        case .none: ""
        }
    }
    
    var description:String {
        switch self {
        case .error: "Please try again later"
        case .empty: "No items to display"
        case .search: "Try a new search"
        case .connection: "Check USB Connection"
        case .none:  ""
        }
    }
    
    var image:String {
        switch self {
        case .error: "exclamationmark.triangle"
        case .empty: "viewfinder"
        case .search: "magnifyingglass"
        case .connection: "cable.connector.slash"
        case .none:  ""
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
                if type != .none {
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
                    .modifier(PageMod())
                    .clipShape(.rect(cornerRadius: 8))
                }
            }
    }
}
