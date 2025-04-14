//
//  TransferView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI


struct TransferView: View {
    @State private var vm = TransferVM()
    @AppStorage("defaultTransferDir") private var defaultTransferDir:URL = FileKit.defaultTransferDir
    @State var progress: Float = 0
    @State var fileName:String = "N/A"
    @State var sheetType:ProgressSheetType = .copyToPC
    var body: some View {
        VStack(spacing:12) {
            VStack(spacing:4) {
                FolderListHeader()
                Group {
                    if vm.isLoading {
                        LoadingView()
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(vm.storageContent) { item in
                                    FolderListItem(defaultLocation: defaultTransferDir,
                                                   item:item,
                                                   fileName: $fileName,
                                                   sheetType:$sheetType)
                                }
                            }
                            .environment(\.transferVM,vm)
                        }
                        .padding(.trailing, -16)
                        .modifier(UnavailableMod(type: vm.storageContent.isEmpty ? .empty : .none ))
                    }
                }
            }
            .modifier(SectionMod(sectionType: .fullWidth))
            
            HStack {
                TransferActionButton(
                    type: .destination(defaultTransferDir),
                    defaultLocation: $defaultTransferDir,
                    isDeactive: vm.isLoading || vm.storageContent.isEmpty || vm.isProceeding,
                    sheetType:$sheetType,
                    fileName:$fileName
                )
                Spacer()
                Button {
                    Task {
                        await vm.getInternalStorage()
                    }
                } label: {
                    Text("Refresh")
                }
                .buttonStyle(ButtonStyles(type:.normal, disable: vm.isLoading || vm.isProceeding, padV: 6,pointerStyle: .link ))

                Spacer()
                TransferActionButton(
                    defaultLocation: $defaultTransferDir,
                    isDeactive: vm.isLoading || vm.storageContent.isEmpty || vm.isProceeding,
                    sheetType:$sheetType,
                    fileName:$fileName
                )
                
            }
            .environment(\.transferVM,vm)
            .modifier(SectionMod(sectionType: .fullWidth))
        }
        .sheet(isPresented: $vm.showActionSheet) {
            ProgressSheet(progress: $progress,
                          fileName: fileName,
                          isCompleted: sheetType == .delete ? !vm.isDeleting:!vm.isCopying,
                          type: sheetType,
                          cancelAction: vm.cancelActiveTask
            )
                .interactiveDismissDisabled()
                .frame(width: 400)
        }
        .task {
            await vm.createDefaultDir()
            await vm.getInternalStorage()
        }
    }
}

#Preview {
    TransferView()
}
