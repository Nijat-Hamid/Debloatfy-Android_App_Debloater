//
//  VisualEffect.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/7/25.
//

import SwiftUI

enum VisualEffectType {
    case sidebar
    case card
    case background
    case others(NSVisualEffectView.Material)
}

struct VisualEffect: NSViewRepresentable {
    private var material: NSVisualEffectView.Material
    private var alpha: CGFloat
    
    
    init(_ type:VisualEffectType){
        switch type {
        case .sidebar:
            material = .sidebar
            alpha = 1
            
        case .card:
            material = .titlebar
            alpha = 0.5
            
        case .background:
            material = .hudWindow
            alpha = 1
        case .others(let others):
            material = others
            alpha = 1
        }
        
    }
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        
        view.material = material
        view.blendingMode = .behindWindow
        view.state = .active
        view.isEmphasized = true
        view.alphaValue = alpha
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = .behindWindow
        nsView.state = .active
        nsView.isEmphasized = true
        nsView.alphaValue = alpha
    }
}
