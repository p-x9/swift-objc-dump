//
//  ObjCField.swift
//
//
//  Created by p-x9 on 2024/06/21
//  
//

import Foundation

public struct ObjCField: Equatable {
    public let type: ObjCType
    public var name: String?
    public var bitWidth: Int?

    package init(
        type: ObjCType,
        name: String? = nil,
        bitWidth: Int? = nil
    ) {
        self.type = type
        self.name = name
        self.bitWidth = bitWidth
    }
}

extension ObjCField: ObjCTypeDecodable {
    public func decoded(tab: String = "    ") -> String {
        if let bitWidth {
            "\(type.decoded(tab: tab)) \(name ?? "x") : \(bitWidth);"
        } else {
            "\(type.decoded(tab: tab)) \(name ?? "x");"
        }
    }

    public func decoded(fallbackName: String, tab: String = "    ") -> String {
        if let bitWidth {
            "\(type.decoded(tab: tab)) \(name ?? fallbackName) : \(bitWidth);"
        } else {
            "\(type.decoded(tab: tab)) \(name ?? fallbackName);"
        }
    }
}

extension ObjCField: ObjCTypeEncodable {
    public func encoded() -> String {
        if let bitWidth {
            if let name {
                return "\"\(name)\"b\(bitWidth)"
            } else {
                return "b\(bitWidth)"
            }
        } else {
            if let name {
                return "\"\(name)\"\(type.encoded())"
            } else {
                return "\(type.encoded())"
            }
        }
    }
}
