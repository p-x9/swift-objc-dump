//
//  ObjCType+.swift
//
//
//  Created by p-x9 on 2024/06/23
//  
//

import Foundation
import ObjCTypeDecodeKit

extension ObjCType {
    var decodedStringForArgument: String {
        switch self {
        case .struct(let name, let field):
            if let name {
                return name
            } else {
                let type: ObjCType = .struct(name: nil, fields: field)
                return type.decoded(tab: "")
            }
        case .union(let name, let field):
            if let name {
                return name
            } else {
                let type: ObjCType = .union(name: nil, fields: field)
                return type.decoded(tab: "")
            }
        // Objective-C BOOL types may be represented by signed char or by C/C++ bool types.
        // This means that the type encoding may be represented as C(c) or as B.
        // [reference](https://github.com/apple-oss-distributions/objc4/blob/01edf1705fbc3ff78a423cd21e03dfc21eb4d780/runtime/objc.h#L61-L86)
        case .char: fallthrough
        case .uchar:
            return "BOOL"
        default:
            break
        }
        
        return decoded(tab: "")
            .components(separatedBy: .newlines)
            .joined(separator: " ")
    }
}
