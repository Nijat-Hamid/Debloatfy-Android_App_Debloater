//
//  AppToolbarVieü.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/7/25.
//

import SwiftUI

enum AppToolbarType {
    case debloat
    case restore
}

struct AppToolbarView: View {
    
    var body: some View {
        HStack {
            SearchInputView()
            Spacer()
            HStack(spacing:16) {
                Button {
                    print("Batch Remove")
                } label: {
                    Label("Remove", systemImage: "trash")
                }
                .buttonStyle(ButtonStyles(type: .danger,padV: 8))
                
                Button {
                    print("Backup and Remove")
                } label: {
                    Label("Backup & Remove", systemImage: "arrow.up.trash")
                }
                .buttonStyle(ButtonStyles(type: .warning,padV: 8))
            }
            .font(.appHeadline)
            .fontWeight(.semibold)
        }
        
    }
}

#Preview {
    AppToolbarView()
        .modifier(PreviewMod(type: .card,width: 600))
}
