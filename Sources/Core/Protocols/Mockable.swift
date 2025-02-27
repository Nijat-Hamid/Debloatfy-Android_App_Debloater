//
//  Mockable.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/27/25.
//

protocol Mockable {
    
    associatedtype MockType
    
    static var mock: MockType { get }
    
    static var mockList: [MockType] { get }
    
    static func mockFunc() -> MockType
    
}

extension Mockable {
    static var mockList: [MockType] {
        get { [] }
    }
    
    static func mockFunc() -> MockType {
        return mock
    }
}
