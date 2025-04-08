//
//  SelectManager.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/1/25.
//

import SwiftUI

@Observable
final class SelectManager {
    var allSelected:Bool = false
    private(set) var selectedItems:Set<String> = []
    
    var selectedCount:Int {
        selectedItems.count
    }
    
    func toggleAll(items: [AppListModel]) {
        if allSelected {
            selectedItems = Set(items.map { $0.package })
        } else {
            selectedItems.removeAll()
        }
    }
    
    func isSelected(package: String) -> Bool {
        return selectedItems.contains(package)
    }
    
    func toggle(package: String) {
        if selectedItems.contains(package) {
            selectedItems.remove(package)
            if allSelected {
                allSelected = false
            }
        } else {
            selectedItems.insert(package)
            
        }
    }
    
    func resetAllSelect() {
        selectedItems.removeAll()
        allSelected = false
    }
    
    func removeSelected(_ package:String) {
        if selectedItems.contains(package) {
            selectedItems.remove(package)
        }
    }
}
