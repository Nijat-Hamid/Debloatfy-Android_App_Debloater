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
                .frame(width:300,alignment: .leading)
                .padding(.leading,8)
            
            Spacer()
            
            Text("Size")
                .frame(width: 100)
            
            Spacer()
            
            Text("Owner")
                .frame(maxWidth: .infinity)
                .padding(.trailing,6)
            Spacer()
        }
        .font(.appHeadline)
        .frame(maxWidth:.infinity)

    }
}

#Preview {
    FolderListHeader()
}
