//
//  TransferView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI


struct TransferView: View {
    
    @AppStorage("defaultLocation") private var defaultLocation:URL = Utils.getDownloadLocation()
    
    var body: some View {
        VStack(spacing:12) {
            VStack(spacing:4) {
                FolderListHeader()
                ScrollView {
                    LazyVStack {
                        ForEach(0..<14) { item in
                            FolderListItem(defaultLocation: defaultLocation,item:item)
                        }
                    }
                }
                .padding(.trailing, -16)
            }
            .modifier(SectionMod(sectionType: .fullWidth))
            
            HStack {
                TransferActionButton(type: .destination(defaultLocation), defaultLocation: $defaultLocation)
                Spacer()
                TransferActionButton(defaultLocation: $defaultLocation)
                
            }
            .modifier(SectionMod(sectionType: .fullWidth))
        }
    }
}

#Preview {
    TransferView()
}
