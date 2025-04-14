//
//  ConfirmationSheet.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/3/25.
//

import SwiftUI

struct ConfirmationSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding private var type:SheetType
    private let isProceeding:Bool
    private let appCount:Int
    private let onProceed: () -> Void
    
    init(type: Binding<SheetType>,
         isProceeding:Bool,
         appCount:Int,
         onProceed: @escaping () -> Void
    ) {
        self._type = type
        self.isProceeding = isProceeding
        self.appCount = appCount
        self.onProceed = onProceed
    }
    
    var body: some View {
        VStack {
            Image(systemName: type.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
                .padding(.vertical,8)
                .padding(.horizontal,12)
                .background(type.color,in: .rect(cornerRadius: 20))
            
            VStack {
                Text("Confirm \(Text(type.title).fontWeight(.bold)) action!")
                    .font(.appTitle)
                    .fontWeight(.medium)
                
                VStack(spacing:8) {
                    Text("Are you sure you want to proceed with this action?")
                        .font(.appTitle3)
                        .fontWeight(.medium)
                    
                    Text("\(appCount)")
                        .fontWeight(.semibold)
                    +
                    Text(" \(type.description)")
                        .font(.appHeadline)
                        .fontWeight(.medium)
                    
                    if type != .remove {
                        Text("System Apps will be excluded from the backup or restore. Because of Android's restrictions, you will not be able to restore even if you backup the system apps.")
                            .font(.appCallout)
                            .multilineTextAlignment(.center)
                            .frame(height: 48, alignment: .center)
                    }
                }
                .padding(.horizontal, 60)
            }
            
            Divider()
            HStack {
                if type == .backup || type == .backupRemove {
                    Group {
                        Text("Backup to: ")
                        + Text("Documents/Debloatfy")
                            .fontWeight(.semibold)
                    }
                    .padding(.leading,16)
                    .font(.appCallout)
                }
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(.appHeadline)
                        .fontWeight(.medium)
                }
                .buttonStyle(ButtonStyles(
                    type:.normal,
                    disable: isProceeding,
                    pointerStyle: .link))
                
                
                Button {
                    onProceed()
                } label: {
                    Text(isProceeding ? "Proceeding..." : "Proceed")
                        .contentTransition(.numericText())
                        .font(.appHeadline)
                        .fontWeight(.medium)
                        .animation(.default,value: isProceeding)
                }
                .buttonStyle(ButtonStyles(
                    type:type.buttonStyle,
                    disable: isProceeding,
                    pointerStyle: .link))
            }
            .padding(.top,10)
            .padding(.bottom,16)
            .padding(.trailing,16)
        }
        .padding(.top,24)
    }
}

#Preview {
    ConfirmationSheet(
        type:.constant(.restore),
        isProceeding: false,
        appCount: 10,
        onProceed: {}
    )
}

extension ConfirmationSheet {
    enum SheetType {
        case remove, backup, backupRemove,restoreRemove, restore
        
        var title:String {
            switch self {
            case .remove: "Remove"
            case .backup: "Backup"
            case .backupRemove: "Backup and Remove"
            case .restoreRemove: "Restore and Remove"
            case .restore: "Restore"
            }
        }
        
        var description:String {
            switch self {
            case .remove: "app will be deleted"
            case .backup: "app will be backed up"
            case .backupRemove: "app will be deleted after backup"
            case .restoreRemove: "app will be deleted after being restored"
            case .restore: "app will be restored"
            }
        }
        
        var icon:String {
            switch self {
            case .remove: "trash"
            case .backup: "arrow.trianglehead.2.clockwise"
            case .backupRemove: "arrow.up.trash"
            case .restoreRemove: "arrow.up.trash"
            case .restore: "arrow.trianglehead.2.clockwise"
            }
        }
        
        var color:Color {
            switch self {
            case .remove: .reddish
            case .backup: .greenish
            case .backupRemove: .yellowish
            case .restoreRemove: .yellowish
            case .restore: .greenish
            }
        }
        
        var buttonStyle:ButtonTypes {
            switch self {
            case .remove: .danger
            case .backup: .success
            case .backupRemove: .warning
            case .restoreRemove: .warning
            case .restore: .success
            }
        }
    }
}
