//
//  AppListHeader.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/15/25.
//

import SwiftUI

struct AppListHeader: View {
    
    @State private var checkAll:Bool = false
    
    var body: some View {
        HStack {
            Toggle("", isOn: $checkAll)
                .toggleStyle(ToggleStyles(color: .brand))
                .padding(8)
                .background(Color.secondary.opacity(0.2),in: .rect(cornerRadius: 8))
            
            HStack(spacing:0) {
                Text("Name")
                    .padding(.leading,28)
                    .frame(width: 120,alignment: .leading)
                
                Spacer()
                
                Text("Package")
                    .frame(width: 185)
                
                Spacer()
                
                Text("Type")
                    .frame(width: 60)
                
                Spacer()
                
                Text("Size")
                    .frame(width: 70)
                
                Spacer()
                
                Text("Actions")
                    .frame(width: 200)
                
            }
            .font(.appHeadline)
            .padding(8)
            .frame(maxWidth:.infinity)
            .background(Color.secondary.opacity(0.2),in: .rect(cornerRadius: 8))
        }
        
    }
}

#Preview {
    AppListHeader()
        .modifier(PreviewMod(type: .card,width: 500))
}
