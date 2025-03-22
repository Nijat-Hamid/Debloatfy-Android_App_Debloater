//
//  AppListItemLabel.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/17/25.
//

import SwiftUI

struct AppListItemLabel: View {
    
    private var label:String
    private var width:CGFloat
    private var alignment:Alignment
    private var withIcon:Bool
    init(label: String,width:CGFloat = 150,alignment:Alignment = .leading,withIcon:Bool = false) {
        self.label = label
        self.width = width
        self.alignment = alignment
        self.withIcon = withIcon
    }
    
    var body: some View {
        if withIcon {
            Label {
                Text(label)
                    .lineLimit(1)
                    .font(.appHeadline)
                
            } icon: {
                Image(.apk)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color.primary)
                    .frame(width: 16)
            }
            .frame(width: width,alignment: alignment)
            
        } else {
            Text(label)
                .lineLimit(1)
                .frame(width: width,alignment: alignment)
                .font(.appHeadline)
        }
    }
}

#Preview {
    AppListItemLabel(label: "App Name")
        .modifier(PreviewMod(type:.card))
}
