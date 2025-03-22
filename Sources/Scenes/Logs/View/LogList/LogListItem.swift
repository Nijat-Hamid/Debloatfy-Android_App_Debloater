//
//  LogListItem.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/22/25.
//

import SwiftUI

struct LogListItem: View {
    
    var body: some View {
        HStack {
            Text("SEP 26, 2025 | 23:30:56")
                .frame(width:160,alignment: .leading)
            
            Spacer()
            
            Text("Removed")
                .font(.appSubHeadline)
                .padding(4)
                .background(.reddish,in: .rect(cornerRadius: 8))
                .frame(width:140)
            
            Spacer()
            
            Text("com.package.facebook")
                .frame(width:160)
            
            Spacer()
            
            Text("Message")
                .frame(maxWidth: .infinity,alignment: .leading)
        }
        .padding(.vertical,4)
    }
}

#Preview {
    LogListItem()
}
