//
//  InfoDetailView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/1/25.
//

import SwiftUI

struct InfoDetailView: View {
    var body: some View {
        VStack(alignment:.leading ,spacing:8){
            infoRow(title: "Name:", value: AppInfo.appName,icon: "info.square")
            
            infoRow(title: "Version:", value: "v\(AppInfo.appVersion) (Build \(AppInfo.buildNumber))",icon:"apple.terminal.on.rectangle")
            
            infoRow(title: "Target:", value: "MacOS \(AppInfo.minOSVersion)",icon: "drop.keypad.rectangle")
            
            infoRow(title: "Author:", value: AppInfo.author,icon: "person.fill.viewfinder")
            
            Text(AppInfo.copyright)
                .fontWeight(.medium)
                .font(.appTitle3)
                .padding(.top,4)
                .frame(width: 300)
        }
    }
    
    private func infoRow(title: String, value: String,icon:String) -> some View {
        Label {
            HStack(spacing: 4) {
                Text(title)
                    .fontWeight(.semibold)
                Text(value)
            }
        } icon: {
            Image(systemName: icon)
                .resizable()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.foregroundPrimary, .brand)
                .frame(width: 18,height: 18)
        }
        .font(.appTitle3)
    }
}

#Preview {
    InfoDetailView()
        .modifier(PreviewMod(type: .card,width:nil))
}
