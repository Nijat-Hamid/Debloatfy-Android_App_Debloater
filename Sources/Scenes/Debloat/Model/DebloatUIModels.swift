//
//  DebloatUIModels.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/18/25.
//

struct SingleApkModel:Codable {
    let fileName:String
    let originalPath:String
}

struct PackageInfo:Codable {
    let type:String
    let totalSize:String
    let apks:[SingleApkModel]
}
