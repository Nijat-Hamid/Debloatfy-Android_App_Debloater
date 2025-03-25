//
//  FolderListMenuItem.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/24/25.
//

import SwiftUI

struct FolderListMenuItem: View {
    
    private let title:String
    private let action: () -> Void
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FolderListMenuItem(title: "Copy") {
        print("Copied")
    }
}
