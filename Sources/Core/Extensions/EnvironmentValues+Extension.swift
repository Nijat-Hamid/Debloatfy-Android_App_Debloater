//
//  EnvironmentValues+Extension.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/15/25.
//
import SwiftUI

struct DebloatViewModel:@preconcurrency EnvironmentKey {
    @MainActor static var defaultValue = DebloatVM()
}

struct RestoreViewModel:@preconcurrency EnvironmentKey {
    @MainActor static var defaultValue = RestoreVM()
}

extension EnvironmentValues {
    @Entry var layoutVM = LayoutVM()
    
    var debloatVM: DebloatVM {
        get { self[DebloatViewModel.self] }
        set { self[DebloatViewModel.self] = newValue  }
    }
    
    var restoreVM: RestoreVM {
        get { self[RestoreViewModel.self] }
        set { self[RestoreViewModel.self] = newValue  }
    }
}
