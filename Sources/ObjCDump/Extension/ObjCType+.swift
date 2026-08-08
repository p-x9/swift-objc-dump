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
    func decodedForProperty(declarator name: String) -> String {
        if let headerTypeName {
            return "\(headerTypeName) \(name)"
        }
        return decoded(declarator: name)
    }

    var decodedStringForArgument: String {
        if let headerTypeName {
            return headerTypeName
        }
        switch self {
        case .struct(_, let fields):
            let type: ObjCType = .struct(name: nil, fields: fields)
            return type.decoded(tab: "")
                .components(separatedBy: .newlines)
                .joined(separator: " ")
        case .union(_, let fields):
            let type: ObjCType = .union(name: nil, fields: fields)
            return type.decoded(tab: "")
                .components(separatedBy: .newlines)
                .joined(separator: " ")
        default:
            break
        }
        
        return decoded(tab: "")
            .components(separatedBy: .newlines)
            .joined(separator: " ")
    }

    private var headerTypeName: String? {
        switch self {
        case .struct(let name?, _), .union(let name?, _):
            return name
        // Objective-C BOOL types may be represented by signed char or by C/C++ bool types.
        // This means that the type encoding may be represented as `c` or as `B`.
        // [reference](https://github.com/apple-oss-distributions/objc4/blob/01edf1705fbc3ff78a423cd21e03dfc21eb4d780/runtime/objc.h#L61-L86)
        case .char:
            return "BOOL"
        default:
            return nil
        }
    }
}
