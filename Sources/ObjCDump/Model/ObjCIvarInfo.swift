//
//  ObjCIvarInfo.swift
//
//
//  Created by p-x9 on 2024/06/23
//  
//

import Foundation
import ObjCTypeDecodeKit

/// Structure for representing objc instance variable information.
public struct ObjCIvarInfo {
    /// Name of the Ivar
    public let name: String
    /// Encoded type of the Ivar
    public let typeEncoding: String
    /// Offset of Ivar
    public let offset: Int
    
    /// Initializes a new instance of `ObjCIvarInfo`.
    /// - Parameters:
    ///   - name: Name of the Ivar
    ///   - typeEncoding: Encoded type of the Ivar
    ///   - offset: Offset of Ivar
    public init(
        name: String,
        typeEncoding: String,
        offset: Int
    ) {
        self.name = name
        self.typeEncoding = typeEncoding
        self.offset = offset
    }
    
    /// Initializes a new instance of `ObjCIvarInfo`.
    /// - Parameter ivar: Ivar of the target for which information is to be obtained.
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
    /// Type of Ivar
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
            let type = type?.decoded()
            if let type, type.last == "*" {
                return "\(type)\(name);"
            }
            return "\(type ?? "unknown") \(name);"
        }
    }
}
