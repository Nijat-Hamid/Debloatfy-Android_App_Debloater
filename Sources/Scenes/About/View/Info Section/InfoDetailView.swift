//
//  InfoDetailView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/1/25.
//

import SwiftUI

struct InfoDetailView: View {
    var body: some View {
        HStack() {
            VStack(alignment:.leading ,spacing:8){
                Creator.infoRow(title: "Name:", value: Utils.appName,icon: "info.square")
                
                Creator.infoRow(title: "Version:", value: "v\(Utils.appVersion) (Build \(Utils.buildNumber))",icon:"apple.terminal.on.rectangle")
                
                Creator.infoRow(title: "Target:", value: "MacOS \(Utils.minOSVersion)",icon: "drop.keypad.rectangle")
                
                Creator.infoRow(title: "Author:", value: Utils.author,icon: "person.fill.viewfinder")
                
                Text(Utils.copyright)
                    .fontWeight(.medium)
                    .font(.appTitle3)
                    .frame(width: 300)
            }
            Spacer()
        }
        .modifier(SectionMod(sectionType: .fullWidth))
    }
}

#Preview {
    InfoDetailView()
        .modifier(PreviewMod(type: .card,width:nil))
}
