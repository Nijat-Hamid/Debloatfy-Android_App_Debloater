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
        case .choose: return "Import file:"
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
        case .choose: return [.item, .content, .data]
        }
    }
}

struct TransferActionButton: View {
    @State private var isImporting: Bool = false
    @Binding var defaultLocation: URL
    private let type:TransferActionBtnType
    
    init(type: TransferActionBtnType = .choose, defaultLocation: Binding<URL>) {
        self.type = type
        self._defaultLocation = defaultLocation
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
                        case .destination(_):
                            defaultLocation = url
                        case .choose:
                            print(url)
                        }

                    case .failure(let error):
                        print(error)
                    }
                })
            .buttonStyle(ButtonStyles(type: .normal))
        }
    }
}

#Preview {
    TransferActionButton(type:.choose,defaultLocation: .constant(URL.homeDirectory))
        .modifier(PreviewMod(type: .card, width: 300))
}
