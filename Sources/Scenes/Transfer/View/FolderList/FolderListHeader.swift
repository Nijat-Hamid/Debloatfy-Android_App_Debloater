//
//  FolderListHeader.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/22/25.
//

import SwiftUI

struct FolderListHeader: View {
    var body: some View {
        HStack(spacing:12) {
            Text("Name")
                .frame(width: 160,alignment: .leading)
                .padding(.leading,8)
            
            Spacer()
            
            Text("Size")
                .frame(width: 100)
            
            Spacer()
            
            Text("Modified")
                .frame(width: 160)
            
            Spacer()
            
            Text("Owner")
                .frame(width: 120)
                .padding(.trailing,4)
            Spacer()
        }
        .font(.appHeadline)
        .frame(maxWidth:.infinity)

    }
}

#Preview {
    FolderListHeader()
}
