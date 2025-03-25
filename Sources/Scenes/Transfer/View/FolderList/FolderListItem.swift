//
//  FolderListItem.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/22/25.
//

import SwiftUI

struct FolderListItem: View {
    @State private var isHovered:Bool = false
    private let defaultLocation: URL
    private let item:Int
    
    init(defaultLocation: URL,item:Int) {
        self.defaultLocation = defaultLocation
        self.item = item
    }
    

    var body: some View {
        HStack(spacing:0) {
            HStack(spacing:12) {
                Label("MP3", systemImage: "folder")
                    .frame(width:160,alignment: .leading)
                    .padding(.leading,8)
                
                Spacer()
                
                Text("128GB")
                    .frame(width:100)
                
                Spacer()
                
                Text("SEP 25,2025")
                    .frame(width:160)
                
                Spacer()
                
                Text("System")
                    .frame(width: 110)
                Spacer()
            }
            .padding(.vertical,6)
            .frame(width:786)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.secondary.opacity(isHovered ? 0.5 : 0))
                    .animation(.snappy, value: isHovered)
            }
            .onHover { hovering in
                withAnimation {
                    isHovered = hovering
                }
            }
            .contextMenu {
                ZStack {
                    FolderListMenuItem(title: "Copy to ...") {
                        print(item)
                    }
                    Divider()
                    FolderListMenuItem(title: "Copy to \(defaultLocation.lastPathComponent)") {
                        print("copied")
                    }
                    Divider()
                    FolderListMenuItem(title: "Remove") {
                        print("copied")
                    }
                }
                .isHidden(!isHovered)
            }
            Spacer()
        }
    }
}

#Preview {
    FolderListItem(defaultLocation: .userDirectory,item: 1)
        .modifier(PreviewMod(type:.card,width: 400))
}
