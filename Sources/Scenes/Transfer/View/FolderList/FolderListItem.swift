//
//  FolderListItem.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/22/25.
//

import SwiftUI

struct FolderListItem: View {
    @Environment(TransferVM.self) private var vm
    @State private var isHovered:Bool = false
    @Binding private var fileName:String
    @Binding private var sheetType:ProgressSheetType
    private let defaultLocation: URL
    private let item:TransferModel
    
    init(defaultLocation: URL,
         item:TransferModel,
         fileName:Binding<String>,
         sheetType:Binding<ProgressSheetType>
    ) {
        self.defaultLocation = defaultLocation
        self.item = item
        self._fileName = fileName
        self._sheetType = sheetType
    }
    

    var body: some View {
        HStack(spacing:0) {
            HStack(spacing:12) {
                Label(item.name, systemImage: item.type == .folder ? "folder" : "document")
                    .frame(width:300,alignment: .leading)
                    .padding(.leading,item.type == .folder ? 8 : 10)
                
                Spacer()
                
                Text(Utils.formatSize(item.size))
                    .frame(width:100)
                
                Spacer()
                
                Text(item.owner)
                    .frame(maxWidth: .infinity)
                Spacer()
            }
            .frame(width:786, height: 28)
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
                Group {
                    FolderListMenuItem(title: "Copy to \(defaultLocation.lastPathComponent)") {
                        sheetType = .copyToPC
                        fileName = item.name
                        vm.setActiveTask {
                            await vm.copyToPC(item.name, copyLocation: defaultLocation.path())
                        }
                    }
                    Divider()
                    FolderListMenuItem(title: "Remove") {
                        sheetType = .delete
                        fileName = item.name
                        
                        vm.setActiveTask {
                            item.type == .file ?
                            await vm.deleteContent(item.name, isDirectory: false) :
                            await vm.deleteContent(item.name, isDirectory: true)
                        }
                    }
                }
                .isHidden(!isHovered)
            }
            Spacer()
        }
    }
}

#Preview {
    FolderListItem(defaultLocation: .userDirectory,
                   item: TransferModel.mock,
                   fileName: .constant("N/A"),
                   sheetType: .constant(.copyToPC))
        .modifier(PreviewMod(type:.card,width: nil))
}
