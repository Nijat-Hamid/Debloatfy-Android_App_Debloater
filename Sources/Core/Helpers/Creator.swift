//
//  Creator.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/4/25.
//

import SwiftUI

struct Creator {
    static func infoRow(
        title: String,
        value: String,
        icon:String,
        spacing:CGFloat = 4,
        onlyTitle:Bool = false,
        fontWeight:Font.Weight = .semibold,
        iconMode:SymbolRenderingMode = .palette,
        size:CGSize = .init(width: 18, height: 18),
        font:Font = .appTitle3
    ) -> some View {
        Label {
            HStack(spacing: spacing) {
                Text(title)
                    .fontWeight(fontWeight)
                if !onlyTitle {
                    Text(value)
                }
            }
        } icon: {
            Image(systemName: icon)
                .resizable()
                .symbolRenderingMode(iconMode)
                .foregroundStyle(Color.primary, .brand)
                .frame(width: size.width,height: size.height)
        }
        .font(font)
    }
}
