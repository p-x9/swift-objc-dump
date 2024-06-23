//
//  ObjCIvarInfo.swift
//
//
//  Created by p-x9 on 2024/06/23
//  
//

import Foundation
import ObjCTypeDecodeKit

public struct ObjCIvarInfo {
    let name: String
    let typeEncoding: String
    let offset: Int
}

extension ObjCIvarInfo {
    public var type: ObjCType? {
        ObjCTypeDecoder.decode(typeEncoding)
    }
}

extension ObjCIvarInfo {
    public var headerString: String {
        if let type, case let .bitField(width) = type {
            let field = ObjCField(
                type: .int,
                name: name,
                bitWidth: width
            )
            return field.decoded(fallbackName: name)
        } else {
            return "\(type?.decoded() ?? "unknown") \(name);"
        }
    }
}
