//
//  ToggleStyles.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/17/25.
//

import SwiftUI

struct ToggleStyles: ToggleStyle {
    private var color: Color
    private var spacing: CGFloat
    
    init(color: Color = .brand,
         spacing:CGFloat = 4
    ) {
        self.color = color
        self.spacing = spacing
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let isLabelEmpty = Mirror(reflecting: configuration.label).children.isEmpty
        
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(spacing: isLabelEmpty ? 0 : spacing) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundStyle(configuration.isOn ? color : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
                    .animation(.snappy, value:configuration.isOn)
                
                configuration.label
            }
        }
        .buttonStyle(.plain)
    }
}
