//
//  AppActionItem.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/19/25.
//

import SwiftUI

struct AppActionItem: View {
    
    private let icon:String
    private let title:String
    private let action: () -> Void
    private let size:CGFloat
    private let type:ButtonTypes
    @State private var isHover:Bool = false
    
    init(title:String,icon: String,size:CGFloat = 14,type:ButtonTypes = .normal,action: @escaping ()->Void) {
        self.title = title
        self.icon = icon
        self.action = action
        self.size = size
        self.type = type
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing:isHover ? 4 : 0) {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:size)
                ZStack {
                    if isHover {
                        Text(title)
                            .font(.appSubHeadline)
                            .fontWeight(.semibold)
                            .transition(.opacity)
                    }
                }
            }
        }
        .buttonStyle(ButtonStyles(type: type,padV: 4,padH: 6,pointerStyle: .link))
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.snappy) {
                isHover = hovering
            }
    
        }
    }
}

#Preview {
    VStack {
        AppActionItem(title: "Remove",icon: "trash",type: .danger){
            print("pressed")
        }
        
        AppActionItem(title: "Restore",icon: "arrow.trianglehead.2.clockwise",type: .success){
            print("pressed")
        }
        
        AppActionItem(title: "Backup&Remove",icon: "arrow.up.trash",type: .warning){
            print("pressed")
        }
    }
    .modifier(PreviewMod())
}
