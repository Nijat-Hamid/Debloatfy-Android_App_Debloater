//
//  LogListHeader.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/22/25.
//

import SwiftUI

struct LogListHeader: View {
    var body: some View {
        HStack(spacing:0) {
            Text("Date")
                .frame(width: 160,alignment: .leading)
            
            Spacer()
            
            Text("Method")
                .frame(width: 140)
            
            Spacer()
            
            Text("Name")
                .frame(width: 160)
            
            Spacer()
            
            Text("Message")
                .frame(maxWidth: .infinity)
        }
        .font(.appHeadline)
        .frame(maxWidth:.infinity)
    }
}

#Preview {
    LogListHeader()
}
