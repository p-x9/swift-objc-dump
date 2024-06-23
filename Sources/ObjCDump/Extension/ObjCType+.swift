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
        default:
            break
        }
        return decoded(tab: "")
            .components(separatedBy: .newlines)
            .joined(separator: " ")
    }
}
