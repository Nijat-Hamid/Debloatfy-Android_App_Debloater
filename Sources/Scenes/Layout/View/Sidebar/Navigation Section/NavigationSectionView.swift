//
//  NavigationSectionView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/21/25.
//

import SwiftUI

struct NavigationSectionView: View {
    
    let navigationData: [Section<NavigationItem>]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(navigationData) { section in
                VStack(alignment: .leading, spacing: 2) {
                    Text(section.title)
                        .font(.appHeadline)
                        .foregroundStyle(Color.mute)
                        .padding(.horizontal, 8)
                    
                    ForEach(section.items) { item in
                        NavigationItemView(navigationItem: item)
                    }
                }
            }
        }
    }
}


#Preview {
    NavigationSectionView(navigationData: [])
}
