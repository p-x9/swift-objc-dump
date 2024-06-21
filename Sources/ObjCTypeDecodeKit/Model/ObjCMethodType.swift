//
//  ObjCMethodType.swift
//
//
//  Created by p-x9 on 2024/06/22
//  
//

import Foundation

public struct ObjCMethodType {
    public struct ArgumentInfo {
        public let type: ObjCType
        public let offset: Int
    }

    public let returnType: ObjCType
    public let stackSize: Int
    public let selfInfo: ArgumentInfo
    public let argumentInfos: [ArgumentInfo]
}

extension ObjCMethodType: ObjCTypeEncodable {
    public func encoded() -> String {
        let arguments = argumentInfos
            .map({ $0.encoded() })
            .joined()
        return "\(returnType.encoded())\(stackSize)\(selfInfo.encoded())\(arguments)"
    }
}

extension ObjCMethodType.ArgumentInfo: ObjCTypeEncodable {
    public func encoded() -> String {
        "\(type.encoded())\(offset)"
    }
}
