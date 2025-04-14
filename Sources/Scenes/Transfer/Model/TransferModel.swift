//
//  TransferUIModel.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/10/25.
//

import Foundation

enum TransferModelType {
    case folder, file
}

struct TransferModel: Identifiable, Equatable, Hashable {
    var id: UUID = UUID()
    var name:String = "N/A"
    var size:String = "N/A"
    var owner:String = "User"
    var type:TransferModelType = .file
}

extension TransferModel:Mockable {
    typealias MockType = TransferModel
    
    static var mock: TransferModel {
        MockType(name: "My Pictures", size: "300",type: .folder)
    }
    
    static var mockList: [TransferModel] {
        [
            MockType(name: "Videos", size: "1.4", type: .folder),
            MockType(name: "Snap", size: "34", type: .folder),
            MockType(name: "Mp3", size: "60", type: .folder),
            MockType(name: "Hans Zimmer - Time", size: "5"),
        ]
    }
}
