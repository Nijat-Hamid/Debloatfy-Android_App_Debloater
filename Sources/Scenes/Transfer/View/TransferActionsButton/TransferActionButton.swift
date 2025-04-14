//
//  FolderSaveDestination.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/22/25.
//

import SwiftUI
import UniformTypeIdentifiers.UTType

enum TransferActionBtnType {
    case destination(URL)
    case choose
    
    var description:String {
        switch self {
        case .destination: return "Copy to:"
        case .choose: return "Import from:"
        }
    }
    
    var title:String {
        switch self {
        case .destination(let url): return url.lastPathComponent
        case .choose: return "Choose"
        }
    }
    
    var types:[UTType] {
        switch self {
        case .destination(_): return [.folder]
        case .choose: return [.item, .content, .data, .folder]
        }
    }
    
    var message:String {
        switch self {
        case .destination(_): return "Choose default location transfer from phone to PC"
        case .choose: return "Choose File/Folder to transfer phone"
        }
    }
    
    var defaultLocation:URL {
        switch self {
        case .destination(let url): return url
        case .choose: return .desktopDirectory
        }
    }
}

struct TransferActionButton: View {
    @Environment(\.transferVM) private var vm
    @State private var isImporting: Bool = false
    @Binding private var defaultLocation: URL
    @Binding private var sheetType:ProgressSheetType
    @Binding private var fileName:String
    private let type:TransferActionBtnType
    private let isDeactive:Bool
    
    init(type: TransferActionBtnType = .choose,
         defaultLocation: Binding<URL>,
         isDeactive:Bool = false,
         sheetType: Binding<ProgressSheetType>,
         fileName:Binding<String>
    ) {
        self.isDeactive = isDeactive
        self.type = type
        self._defaultLocation = defaultLocation
        self._sheetType = sheetType
        self._fileName = fileName
    }
    
    var body: some View {
        HStack(spacing:4) {
            Text(type.description)
            Button {
                isImporting = true
            }  label: {
                Text("\(type.title)")
            }
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: type.types,
                onCompletion: { result in
                    switch result {
                    case .success(let url):
                        switch type {
                        case .destination:
                            defaultLocation = url
                        case .choose:
                            fileName = url.lastPathComponent
                            sheetType = .copyToPhone
                            vm.setActiveTask {
                                await vm.copyToPhone(url.path())
                            }
                        }
                    case .failure(let error):
                        Log.of(.viewCycle(TransferActionButton.self)).error("\(error.localizedDescription)")
                    }
                })
            .fileDialogMessage(type.message)
            .fileDialogDefaultDirectory(type.defaultLocation)
            .buttonStyle(ButtonStyles(type: .normal,disable: isDeactive, padV: 6,pointerStyle: .link))
        }
    }
}

#Preview {
    TransferActionButton(type:.choose,defaultLocation: .constant(URL.homeDirectory), sheetType: .constant(.copyToPC), fileName: .constant("N/A"))
        .modifier(PreviewMod(type: .card, width: 300))
}
