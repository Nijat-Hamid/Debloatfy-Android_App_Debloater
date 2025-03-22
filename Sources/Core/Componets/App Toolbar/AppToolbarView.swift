//
//  AppToolbarVieü.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/7/25.
//

import SwiftUI

enum AppToolbarType {
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

struct AppToolbarView: View {
    
    private let type:AppToolbarType
    
    init(type: AppToolbarType = .debloat) {
        self.type = type
    }
    
    var body: some View {
        HStack {
            SearchInputView()
            Spacer()
            HStack(spacing:12) {
                Button {
                } label: {
                    Text("Selected: 0")
                }
                .buttonStyle(ButtonStyles(type: .normal,disable: true,padV: 6))
                
                Button {
                    print("Batch Remove")
                } label: {
                    Text("Refresh")
                }
                .buttonStyle(ButtonStyles(type: .normal,padV: 6))
                
                Button {
                    print("Batch Remove")
                } label: {
                    Text(type.btnOne)
                }
                .buttonStyle(ButtonStyles(type: .success,padV: 6))
                
                Button {
                    print("Backup and Remove")
                } label: {
                    Text(type.btnTwo)
                }
                .buttonStyle(ButtonStyles(type: .warning,padV: 6))
                
                Button {
                    print("Batch Remove")
                } label: {
                    Text("Remove")
                }
                .buttonStyle(ButtonStyles(type: .danger,padV: 6))
                
            }
            .font(.appHeadline)
            .fontWeight(.semibold)
        }
        .modifier(SectionMod(sectionType: .fullWidth))
        
    }
}

#Preview {
    AppToolbarView()
        .modifier(PreviewMod(type: .card,width: 600))
}
