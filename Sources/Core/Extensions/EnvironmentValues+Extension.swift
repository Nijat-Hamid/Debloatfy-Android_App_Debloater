//
//  EnvironmentValues+Extension.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/15/25.
//
import SwiftUI
extension EnvironmentValues {
    @Entry var layoutVM = LayoutVM()
    @Entry var router = Router()
    @Entry var auth = Auth.shared
    @Entry var selectManager = SelectManager()
    @Entry var debloatVM = DebloatVM()
//    @Entry var 
}
