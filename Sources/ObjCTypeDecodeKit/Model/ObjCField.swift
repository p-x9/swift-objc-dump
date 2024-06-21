//
//  ObjCField.swift
//
//
//  Created by p-x9 on 2024/06/21
//  
//

import Foundation

public struct ObjCField {
    public let type: ObjCType
    public var name: String?
    public var bitWidth: Int?
}

extension ObjCField: CustomStringConvertible {
    public var description: String {
        if let bitWidth {
            "\(type) \(name ?? "x") : \(bitWidth);"
        } else {
            "\(type) \(name ?? "x");"
        }
    }
}
