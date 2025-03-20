//
//  ButtonStyles.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/3/25.
//

import SwiftUI

enum ButtonTypes:CaseIterable {
    case success,warning,danger,normal
    
    var id:String {
        String(describing: self)
    }
}

struct ButtonStyles:ButtonStyle {
    @State private var isHovered: Bool = false
    
    private let buttonType:ButtonTypes
    private let isDisabled:Bool
    private let paddingV:CGFloat
    private let paddingH:CGFloat
    private let cornerRadius:CGFloat
    private let disableOpacity:CGFloat = 0.5
    private let pressedScale:CGFloat = 0.96
    
    
    init(type:ButtonTypes = .normal,disable:Bool = false,padV:CGFloat = 4,padH:CGFloat = 12,radius:CGFloat = 8){
        buttonType = type
        isDisabled = disable
        paddingV = padV
        paddingH = padH
        cornerRadius = radius
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.vertical, paddingV)
            .padding(.horizontal,paddingH)
            .background(backgroundWithHoverState(isPressed: configuration.isPressed))
            .clipShape(.rect(cornerRadius: cornerRadius))
            .opacity(isDisabled ? disableOpacity : 1)
            .scaleEffect(configuration.isPressed ? pressedScale : 1.0)
            .animation(.snappy, value: configuration.isPressed)
            .animation(.snappy, value: isHovered)
            .onHover{ hovering in
                isHovered = hovering
            }
            .disabled(isDisabled)
    }
    
    private func backgroundWithHoverState(isPressed: Bool) -> Color {
        if isDisabled {
            return backgroundColor.opacity(disableOpacity)
        } else if isPressed {
            return pressedColor
        } else if isHovered {
            return hoverColor
        } else {
            return backgroundColor
        }
    }
    
    private var backgroundColor:Color {
        switch buttonType {
        case .success: return .greenish
        case .warning: return .yellowish
        case .danger: return .reddish
        case .normal: return .mute.opacity(0.5)
        }
    }
    
    private var hoverColor: Color {
        backgroundColor.opacity(0.9)
    }
    
    private var pressedColor:Color {
        backgroundColor.opacity(0.8)
    }
    
}


#Preview {
    VStack(alignment:.leading,spacing: 12) {
        ForEach(ButtonTypes.allCases,id: \.self) { button in
            Button {
                print("Button Pressed")
            } label: {
                Text(button.id)
            }
            .buttonStyle(ButtonStyles(type: button))
        }
        
        Button {
            print("Button Pressed")
        } label: {
            Text("disabled")
        }
        .buttonStyle(ButtonStyles(type: .normal,disable: true))
        .disabled(true)
    }
    .modifier(PreviewMod(type:.card))
}
