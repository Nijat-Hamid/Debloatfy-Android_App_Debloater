//
//  DebloatListHeader.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/15/25.
//

import SwiftUI

struct DebloatListHeader: View {
    
    @State private var checkAll:Bool = false
    
    var body: some View {
        HStack {
            Toggle("", isOn: $checkAll)
                .toggleStyle(ToggleStyles(color: .brand))
                .padding(8)
                .background(Color.secondary.opacity(0.2),in: .rect(cornerRadius: 8))
            
            HStack(spacing:0) {
                Text("Name")
                    .frame(width: 150,alignment: .leading)
                
                Spacer()
                
                Text("Package")
                    .frame(width: 185,alignment: .leading)
                
                Spacer()
                
                Text("Type")
                    .frame(width: 84,alignment: .leading)
                
                Spacer()
                
                Text("Size")
                    .frame(width: 120,alignment: .leading)
                
            }
            .font(.appHeadline)
            .padding(8)
            .frame(maxWidth:.infinity)
            .background(Color.secondary.opacity(0.2),in: .rect(cornerRadius: 8))
        }
        
    }
}

#Preview {
    DebloatListHeader()
        .modifier(PreviewMod(type: .card,width: 500))
}
