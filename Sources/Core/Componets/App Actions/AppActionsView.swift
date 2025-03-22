//
//  AppActionsView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/19/25.
//

import SwiftUI

enum AppActionsType {
    case debloat
    case restore
    
    var btnOne:String {
        switch self {
        case .debloat: return "Backup"
        case .restore: return "Restore"
        }
    }
    
    var btnTwo:String {
        switch self {
        case .debloat: return "Backup&Remove"
        case .restore: return "Restore&Remove"
        }
    }
}

struct AppActionsView: View {
    private let width:CGFloat
    private let type:AppActionsType
    
    init(type:AppActionsType = .debloat ,width: CGFloat) {
        self.width = width
        self.type = type
    }
    
    var body: some View {
        HStack(spacing:8) {
            AppActionItem(title: type.btnOne, icon: "arrow.trianglehead.2.clockwise",size: 12,type: .success) {
                print("pressed")
            }
            
            AppActionItem(title: type.btnTwo, icon: "arrow.up.trash",size: 12,type: .warning) {
                print("pressed")
            }
            
            AppActionItem(title: "Remove", icon: "trash",size: 12,type: .danger) {
                print("pressed")
            }
        }
        .frame(width:width)
    }
}

#Preview {
    AppActionsView(width: 92)
        .modifier(PreviewMod(type:.card))
}
