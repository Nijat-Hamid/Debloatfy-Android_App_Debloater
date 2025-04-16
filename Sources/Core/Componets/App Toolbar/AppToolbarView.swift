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
    
    @Environment(\.selectManager) private var selectManager
    @Binding private var searchText: String
    @State private var showConfirmationSheet = false
    @State private var sheetType: ConfirmationSheet.SheetType = .backup
    @State private var pendingAction: (() async -> ())? = nil
    
    private let type:AppToolbarType
    private let refreshAction: () async -> ()
    private let primaryAction: () async -> ()
    private let secondaryAction: () async -> ()
    private let removeAction: () async -> ()
    private let isLoading: Bool
    private let isProceeding:Bool
    
    init(type: AppToolbarType = .debloat,
         refreshAction: @escaping @Sendable () async -> (),
         removeAction: @escaping @Sendable () async -> (),
         primaryAction: @escaping @Sendable () async -> (),
         secondaryAction: @escaping @Sendable () async -> (),
         isLoading:Bool,
         searchText:Binding<String>,
         isProceeding:Bool
    ) {
        self.type = type
        self.refreshAction = refreshAction
        self.removeAction = removeAction
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.isLoading = isLoading
        self._searchText = searchText
        self.isProceeding = isProceeding
    }
    
    var body: some View {
        HStack {
            SearchInputView(isLoading: isLoading,searchText: $searchText)
            Spacer()
            HStack(spacing:12) {
                Button {
                } label: {
                    Text("Selected: \(selectManager.selectedCount)")
                        .contentTransition(.numericText())
                        .animation(.default, value: selectManager.selectedCount)
                }
                .buttonStyle(ButtonStyles(type: .normal,disable: true,padV: 6))
                
                Button {
                    Task {
                       await refreshAction()
                    }
                    selectManager.resetAllSelect()
                    
                } label: {
                    Text("Refresh")
                }
                .buttonStyle(ButtonStyles(
                    type: .normal,
                    disable: isLoading,
                    padV: 6,
                    pointerStyle: .link))
                
                Button {
                    sheetType = type == .debloat ? .backup : .restore
                    pendingAction = primaryAction
                    showConfirmationSheet = true
                } label: {
                    Text(type.btnOne)
                }
                .buttonStyle(ButtonStyles(
                    type: .success,
                    disable: isLoading || selectManager.selectedCount == 0,
                    padV: 6,
                    pointerStyle: .link))
                
                Button {
                    sheetType = type == .debloat ? .backupRemove : .restoreRemove
                    pendingAction = secondaryAction
                    showConfirmationSheet = true
                } label: {
                    Text(type.btnTwo)
                }
                .buttonStyle(ButtonStyles(
                    type: .warning,
                    disable: isLoading || selectManager.selectedCount == 0,
                    padV: 6,
                    pointerStyle: .link))
                
                Button {
                    sheetType = .remove
                    pendingAction = removeAction
                    showConfirmationSheet = true
                } label: {
                    Text("Remove")
                }
                .buttonStyle(ButtonStyles(
                    type: .danger,
                    disable: isLoading || selectManager.selectedCount == 0,
                    padV: 6,
                    pointerStyle: .link))
                
            }
            .font(.appHeadline)
            .fontWeight(.semibold)
        }
        .modifier(SectionMod(sectionType: .fullWidth))
        .sheet(isPresented: $showConfirmationSheet) {
            ConfirmationSheet(
                type: $sheetType,
                isProceeding: isProceeding,
                appCount: selectManager.selectedCount
            ) {
                if let action = pendingAction {
                    Task {
                        await action()
                        await MainActor.run {
                            pendingAction = nil
                            showConfirmationSheet = false
                        }
                        
                    }
                }
            }
            .interactiveDismissDisabled()
        }
        
    }
}

#Preview {
    AppToolbarView(
        refreshAction: { print("Refresh tapped") },
        removeAction: { print("Remove tapped") },
        primaryAction: { print("Primary button tapped") },
        secondaryAction: { print("Secondary button tapped") },
        isLoading: false,
        searchText: .constant("Search"),
        isProceeding: false
    )
        .modifier(PreviewMod(type: .card,width: 750))
}
