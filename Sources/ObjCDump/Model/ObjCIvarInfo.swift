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
    public let name: String
    public let typeEncoding: String
    public let offset: Int

    public init(
        name: String,
        typeEncoding: String,
        offset: Int
    ) {
        self.name = name
        self.typeEncoding = typeEncoding
        self.offset = offset
    }

    public init?(_ ivar: Ivar) {
        guard let _name = ivar_getName(ivar),
              let _typeEncoding = ivar_getTypeEncoding(ivar) else {
            return nil
        }

        self.init(
            name: String(cString: _name),
            typeEncoding: String(cString: _typeEncoding),
            offset: ivar_getOffset(ivar)
        )
    }
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
