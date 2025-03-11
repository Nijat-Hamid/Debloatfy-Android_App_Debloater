//
//  DebloatView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct DebloatView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            AppToolbarView()
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Debloat ")
                    .font(.appTitle3)
                    .fontWeight(.semibold)
//                    .padding(.top,-10)
//                    .padding(.bottom,5)
//                    .offset(x:40)
            }
            
        }
        .toolbarTitleDisplayMode(.inline)
        .modifier(SectionMod())
    }
}

#Preview {
    DebloatView()
        .modifier(PreviewMod(type: .card,width: nil))
}
